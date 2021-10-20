class_name Maze

extends Node2D

const Room = preload("res://Scripts/Room.gd")
const MazePath = preload("res://Scripts/MazePath.gd")

var print_maze = null


func _ready():
	# 乱数生成
	randomize()


# 現在地が床か
func is_floor(maze:Array, x:int, y:int):
	return maze[y][x] == 0


# 現在地が壁か
func is_wall(maze:Array, x:int, y:int):
	return maze[y][x] == 1


# 床をセット
func set_floor(maze:Array, x:int, y:int):
	maze[y][x] = 0


# 壁をセット
func set_wall(maze:Array, x:int, y:int):
	maze[y][x] = 1


# 迷路生成
func create_maze(size_x:int, size_y:int):
	var maze = []
	var start_list = []
	
	size_x = size_x * 2 + 1
	size_y = size_y * 2 + 1
	
	# 2次元配列を生成
	for y_i in range(size_y):
		maze.append([])
		for x_i in range(size_x):
			if x_i == 0 or y_i == 0 or x_i == size_x - 1 or y_i == size_y - 1:
				# フチはすべて壁
				maze[y_i].append(1)
			else:
				# それ以外は通路
				maze[y_i].append(0)
			
			if x_i % 2 == 0 and y_i % 2 == 0:
				# 通路生成の開始地点リスト
				start_list.append([y_i, x_i])

	# 開始地点をシャッフル
	start_list.shuffle()
	for cell in start_list:
		if is_floor(maze, cell[0], cell[1]):
			var criating_wall_list = []
			create_wall(maze, cell[0], cell[1], criating_wall_list)
	
	return maze
	

# 壁を延ばす
func create_wall(maze:Array, start_x:int, start_y:int, criating_wall_list:Array):
	# 移動可能な方向のリスト
	var can_move_dir = []
	var x = start_x
	var y = start_y
	var is_path = false
	
	# 上に延ばせるか
	if is_floor(maze, start_x, start_y - 1) and not ([y - 2, x] in criating_wall_list):
		can_move_dir.append(0)

	# 右に延ばせるか
	if is_floor(maze, start_x + 1, start_y) and not ([y, x + 2] in criating_wall_list):
		can_move_dir.append(1)

	# 下に延ばせるか
	if is_floor(maze, start_x, start_y + 1) and not ([y + 2, x] in criating_wall_list):
		can_move_dir.append(2)
	
	# 左に延ばせるか
	if is_floor(maze, start_x - 1, start_y) and not ([y, x - 2] in criating_wall_list):
		can_move_dir.append(3)
	
	if can_move_dir.size() > 0:
		# 進める方向があるとき
		# 現在地点を壁にする
		set_wall(maze, x, y)
		criating_wall_list.append([y, x])
		
		# 進める方向の中からランダムな方向に壁を延ばす
		var dir = can_move_dir[randi() % can_move_dir.size()]
		match dir:
			0:
				is_path = is_floor(maze, x, y - 2)
				y -= 1
				set_wall(maze, x, y)
				y -= 1
			1:
				is_path = is_floor(maze, x + 2, y)
				x += 1
				set_wall(maze, x, y)
				x += 1
			2:
				is_path = is_floor(maze, x, y + 2)
				y += 1
				set_wall(maze, x, y)
				y += 1
			3:
				is_path = is_floor(maze, x - 2, y)
				x -= 1
				set_wall(maze, x, y)
				x -= 1
		
		# 進んだ先が床だったら壁延ばしを続ける
		if is_path:
			create_wall(maze, x, y, criating_wall_list)
	else:
		# 進める方向がないとき
		# 一歩前に戻り、引き続き壁を延ばす
		var before = criating_wall_list.pop_back()
		create_wall(maze, before[0], before[1], criating_wall_list)


# 整数版rand_range
func rand_rangei(from:int, to:int):
	return randi() % (to - from) + from

# maze配列から部屋リストを生成
func init_room_list(maze:Array):
	print_maze(maze)
	
	var room_list = []
	var path_list = []
	
	var area_size = 10
	
	var room_area_size = area_size * 1.5
	var path_area_size = area_size * 0.5
	
	var room_min_size = 5
	var room_max_size = 10
	
	# 部屋のセットアップ
	for y_i  in range(maze.size()):
		room_list.append([])
		for x_i  in range(maze[y_i].size()):
			if is_floor(maze, x_i, y_i) and x_i % 2 == 1 and y_i % 2 == 1:
				var room_width = (rand_rangei(room_min_size, room_max_size) + rand_rangei(room_min_size, room_max_size)) / 2
				var room_height = (rand_rangei(room_min_size, room_max_size) + rand_rangei(room_min_size, room_max_size)) / 2
				var room_x = x_i * area_size + room_area_size / 2 - area_size + randi() % int(room_area_size - room_width)
				var room_y = y_i * area_size + room_area_size / 2 - area_size + randi() % int(room_area_size - room_height)
				var room = Room.new(room_x, room_y, room_width, room_height)
				room_list[(y_i - 1) / 2].append(room)
	
	# 道のセットアップ
	for y_i  in range(maze.size()):
		for x_i  in range(maze[y_i].size()):
			if is_floor(maze, x_i, y_i) and (x_i % 2 == 0 or y_i % 2 == 0):
				var map_x = (x_i - 1) / 2
				var map_y = (y_i - 1) / 2
				
				var path_x = x_i * area_size + path_area_size / 2
				var path_y = y_i * area_size + path_area_size / 2
				
				var path = MazePath.new(path_x, path_y)
				print("%d,%d:%d,%d" % [x_i,y_i,map_x,map_y])
				if is_floor(maze, x_i, y_i - 1):
					path.connect_room_list.append(room_list[map_y][map_x])
					print(map_x, ", ", map_y, ", ", "↑")
				if is_floor(maze, x_i + 1, y_i):
					path.connect_room_list.append(room_list[map_y][map_x + 1])
					print(map_x + 1, ", ", map_y, ", ", "→")
				if is_floor(maze, x_i, y_i + 1):
					path.connect_room_list.append(room_list[map_y + 1][map_x])
					print(map_x, ", ", map_y + 1, ", ", "↓")
				if is_floor(maze, x_i - 1, y_i):
					path.connect_room_list.append(room_list[map_y][map_x])
					print(map_x, ", ", map_y, ", ", "←")
				path_list.append(path)

	return [room_list, path_list]

# マップの出力
func print_maze(maze:Array):
	# print_maze = maze
	# update()
	for y in range(maze.size()):
		var txt = ""
		for x in range(maze[y].size()):
			if is_floor(maze, x, y):
				txt += "□"
			if is_wall(maze, x, y):
				txt += "■"
		print(txt)
	pass




func set_maze_tiles(room_list, path_list):
	$TileMap.clear()
	
	# 道の描画
	for path in path_list:
		$TileMap.set_cell(path.pos_x, path.pos_y, 0)
		for room in path.connect_room_list:
			$TileMap.set_cell(room.pos_x, room.pos_y, 0)
			
	# 部屋の描画
	for room_col in room_list:
		for room in room_col:
			for y_i in range(room.tile_data.size()):
				for x_i in range(room.tile_data[y_i].size()):
					$TileMap.set_cell(room.pos_x + x_i, room.pos_y + y_i,room.tile_data[y_i][x_i])
	


func _draw():
	if print_maze == null:
		return
	var mag = 5
	
	var size = 8 * mag
	
	var room_min_size = 5 * mag
	var room_max_size = 10 * mag
	
	var room_size = size * 1.9
	var path_size = size * 0.1
	
	var room_base_color = Color(0.5, 0.2, 0.2)
	var room_color = Color(1, 0.5, 0.5)
	var path_color = Color(0.5, 1, 0.5)

	var room_list = []

	for y_i in range(print_maze.size()):
		for x_i in range(print_maze[y_i].size()):
			room_list.append(null)
			if is_floor(print_maze, x_i, y_i):
				if x_i % 2 == 1 and y_i % 2 == 1:
					var room_width = int(rand_range(room_min_size, room_max_size))
					var room_height = int(rand_range(room_min_size, room_max_size))
					var room_x = x_i * size - (room_size - size) / 2 + randi() % int(room_size - room_width)
					var room_y = y_i * size - (room_size - size) / 2 + randi() % int(room_size - room_height)
					var rect = Rect2(room_x, room_y, room_width, room_height)
					
					draw_rect(Rect2(x_i * size - (room_size - size) / 2, y_i * size - (room_size - size) / 2, room_size, room_size), room_base_color)
					draw_rect(rect, room_color)
				else:
					var start = Vector2(x_i + size / 2, y_i + size / 2)
					#draw_rect(Rect2(x_i * size - (path_size - size) / 2, y_i * size - (path_size - size) / 2, path_size, path_size), path_color)


func _on_Button_pressed():
	var maze = create_maze(3, 3)
	var room_path_list = init_room_list(maze)
	set_maze_tiles(room_path_list[0], room_path_list[1])

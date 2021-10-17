extends Node

class_name Maze

func _ready():
	# 乱数生成
	randomize()
	

# 現在地が床か
func is_floor(maze:Array, x:int, y:int):
	return maze[x][y] == 0


# 現在地が壁か
func is_wall(maze:Array, x:int, y:int):
	return maze[x][y] == 1


# 床をセット
func set_floor(maze:Array, x:int, y:int):
	maze[x][y] = 0


# 壁をセット
func set_wall(maze:Array, x:int, y:int):
	maze[x][y] = 1


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
				start_list.append([x_i, y_i])

	# 開始地点をシャッフル
	start_list.shuffle()
	for cell in start_list:
		if maze[cell[0]][cell[1]] == 0:
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
	if is_floor(maze, start_x, start_y - 1) and not ([x, y - 2] in criating_wall_list):
		can_move_dir.append(0)

	# 右に延ばせるか
	if is_floor(maze, start_x + 1, start_y) and not ([x + 2, y] in criating_wall_list):
		can_move_dir.append(1)

	# 下に延ばせるか
	if is_floor(maze, start_x, start_y + 1) and not ([x, y + 2] in criating_wall_list):
		can_move_dir.append(2)
	
	# 左に延ばせるか
	if is_floor(maze, start_x - 1, start_y) and not ([x - 2, y] in criating_wall_list):
		can_move_dir.append(3)
	
	if can_move_dir.size() > 0:
		# 進める方向があるとき
		# 現在地点を壁にする
		set_wall(maze, x, y)
		criating_wall_list.append([x, y])
		
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


# マップの出力
func print_maze(maze:Array):
	for y in range(maze.size()):
		for x in range(maze[y].size()):
			if is_floor(maze, x, y):
				$TileMap.set_cell(x, y, 0)
			if is_wall(maze, x, y):
				$TileMap.set_cell(x, y, 1)


func _on_Button_pressed():
	var maze = create_maze(5, 5)
	print_maze(maze)

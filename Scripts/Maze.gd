extends Node

class_name Maze

func _ready():
	var maze = create_maze(5, 5)
	print_maze(maze)


# 現在地が床か
func is_floor(maze:Array, x:int, y:int):
	return maze[x][y] == 0


# 現在地が壁か
func is_wall(maze:Array, x:int, y:int):
	return maze[x][y] == 1


# 現在地が生成中の壁か
func is_creating_wall(maze:Array, x:int, y:int):
	return maze[x][y] == 2

# 床をセット
func set_floor(maze:Array, x:int, y:int):
	maze[x][y] = 0


# 壁をセット
func set_wall(maze:Array, x:int, y:int):
	maze[x][y] = 1


# 生成中の壁をセット
func set_creating_wall(maze:Array, x:int, y:int):
	maze[x][y] = 2


func create_maze(size_x:int, size_y:int):
	var maze = []
	var startList = []
	
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
				startList.append([x_i, y_i])

	# 開始地点をシャッフル
	startList.shuffle()
	for cell in startList:
		if maze[cell[0]][cell[1]] == 0:
			pass
	
	return maze
	
	
func print_maze(maze:Array):
	var text = ""
	for y in range(maze.size()):
		for x in range(maze[y].size()):
			text += str(maze[x][y])
		text += "\n"
	print(text)


class_name Room

extends Node

var pos_x = 0
var pos_y = 0
var size_x = 2
var size_y = 2
var tile_data = []


# コンストラクタ
func _init(room_pos_x:int, room_pos_y:int, room_size_x:int, room_size_y:int):
	self.tile_data = []
	self.pos_x = room_pos_x
	self.pos_y = room_pos_y
	self.size_x = room_size_x + 2
	self.size_y = room_size_y + 2
	
	for y_i in range(size_y):
		tile_data.append([])
		for x_i in range(size_x):
			# 部屋の周囲は壁
			if x_i == 0 or x_i == size_x - 1 or y_i == 0 or y_i == size_y - 1:
				tile_data[y_i].append(1)
			else:
				tile_data[y_i].append(0)


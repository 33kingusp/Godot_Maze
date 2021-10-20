class_name MazePath

extends Node

var pos_x = 0
var pos_y = 0
var connect_room_list = []

func _init(path_pos_x:int, path_pos_y:int):
	connect_room_list.clear()
	pos_x = path_pos_x
	pos_y = path_pos_y

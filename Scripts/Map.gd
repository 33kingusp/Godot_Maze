extends Node2D

func _ready():
	for i in range(50):
		$TileMap.set_cell(0, i, 2)
	
	for i in range(50):
		$TileMap.set_cell(1, i, 1)	
	
	pass # Replace with function body.


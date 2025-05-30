extends Node2D
class_name LevelGates

@onready var parent = $".."

func close_gates():
	for door in get_children():
		if door is StaticBody2D:
			door.close()

func open_gates():
	for door in get_children():
		if door is StaticBody2D:
			door.open()

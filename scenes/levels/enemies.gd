extends Node2D
class_name LevelEnemies

var children: Dictionary

func pass_player_position(pos: Vector2):
	for i in get_child_count():
		get_child(i).player_position = pos

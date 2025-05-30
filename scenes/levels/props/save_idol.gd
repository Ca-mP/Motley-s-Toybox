extends Area2D
class_name SaveIdol

@export var area: String
@export var id: int

func interact():
	$"..".save(area, id)

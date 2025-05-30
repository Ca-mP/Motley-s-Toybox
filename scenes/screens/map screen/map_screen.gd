extends Control

var current_room_id: int

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("map-screen"):
		queue_free()

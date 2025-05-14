extends NinePatchRect
class_name MapRoom

@export var id: int

func _ready() -> void:
	var map_screen = $"..".get_parent().get_parent()
	if map_screen.current_room_id == self.id:
		var here_texture = preload("res://sprites/map screen/mapocc.png")
		texture = here_texture

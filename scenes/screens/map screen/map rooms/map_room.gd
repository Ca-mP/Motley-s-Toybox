extends NinePatchRect
class_name MapRoom

@export var id: int

func _ready() -> void:
<<<<<<< HEAD
	var map_screen = $"..".get_parent().get_parent().get_parent()
=======
	var map_screen = $"..".get_parent().get_parent()
>>>>>>> af0fecbcbbc5cc96d338cfe03de0af22e0ede74e
	if map_screen.current_room_id == self.id:
		var here_texture = preload("res://sprites/map screen/mapocc.png")
		texture = here_texture

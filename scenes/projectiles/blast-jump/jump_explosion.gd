extends Explosion

@onready var original_position: Vector2
@onready var root = get_tree().get_root()

func go_to_root():
	var parent = self.get_parent()
	parent.remove_child(self)
	root.add_child(self)
	position = original_position

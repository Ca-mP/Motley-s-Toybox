extends StaticBody2D

func _ready() -> void:
	set_collision_layer_value(1, true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.velocity.y < 0:
			set_collision_mask_value(1, false)
			set_collision_layer_value(2, false)
		else:
			set_collision_mask_value(1, true)
			set_collision_layer_value(2, true)

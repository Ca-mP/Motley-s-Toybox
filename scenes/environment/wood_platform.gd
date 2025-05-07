extends StaticBody2D

@onready var area = $Area2D

var passing := false

func _ready() -> void:
	set_collision_mask_value(1, true)

func _process(_delta: float) -> void:
	if area.get_overlapping_bodies():
		var body = area.get_overlapping_bodies()[0]
		if body.name == "Player":
			if body.velocity.y < 0:
				passing = true
				set_collision_mask_value(1, false)
				set_collision_layer_value(2, false)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	set_collision_mask_value(1, true)
	set_collision_layer_value(2, true)

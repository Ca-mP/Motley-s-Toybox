extends Area2D

@export var collision_shape: CollisionShape2D

@onready var parent = $".."

func _on_body_exited(_body: Node2D) -> void:
	if not GameState.brute_boss_beaten:
		parent.close_gates()

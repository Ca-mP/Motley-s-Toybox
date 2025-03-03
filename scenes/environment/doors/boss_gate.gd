extends StaticBody2D

@onready var parent = $".."
@onready var animator = $AnimationPlayer
@onready var collision_shape = $CollisionShape2D
@onready var player_area = $PlayerArea

var player_entered = false

func _ready() -> void:
	animator.play("opened")
	collision_shape.disabled = true

func open():
	animator.play("open")
	collision_shape.disabled = true

func close():
	if player_entered == false and not GameState.brute_boss_beaten:
		animator.play("close")
		collision_shape.set_deferred("disabled", false)
		player_entered = true

func _on_player_area_body_exited(_body: Node2D) -> void:
	parent.close_gates()

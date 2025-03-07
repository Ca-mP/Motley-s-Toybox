extends Gate

@onready var parent = $".."
@onready var player_area = $PlayerArea

var player_entered = false

func _ready() -> void:
	opened()
	collision_shape.set_deferred("disabled", true)

func close():
	if player_entered == false and not GameState.brute_boss_beaten:
		animator.play("close");
		collision_shape.set_deferred("disabled", false)
		player_entered = true

func open():
	animator.play("open")
	collision_shape.set_deferred("disabled", true)

func _on_player_area_body_exited(_body: Node2D) -> void:
	parent.close_gates()

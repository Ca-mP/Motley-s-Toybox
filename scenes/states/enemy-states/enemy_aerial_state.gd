extends EnemyState

signal land

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)

func enter_state():
	set_physics_process(true)
	animator.play("aerial")

func _physics_process(_delta: float) -> void:
	actor.velocity.x += 4 * actor.direction_to_player
	if actor.is_on_floor():
		land.emit()

func exit_state():
	actor.velocity.x = 0
	set_physics_process(false)

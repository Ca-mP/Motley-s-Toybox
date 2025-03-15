extends EnemyState

func _ready() -> void:
	set_physics_process(false)

func enter_state():
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	pass

func exit_state():
	set_physics_process(false)

extends PlayerState
class_name PlayerDeathState

func _ready() -> void:
	set_physics_process(false)

func enter_state():
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	actor.queue_free()

func exit_state():
	set_physics_process(false)

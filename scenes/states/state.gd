extends Node
class_name State

var in_state: bool

func _ready() -> void:
	set_physics_process(false)

func enter_state():
	set_physics_process(true)

func exit_state():
	set_physics_process(false)

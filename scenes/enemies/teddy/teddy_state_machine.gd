extends Node

@export var starting_state: State
var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_state(starting_state)

func change_state(state):
	print("New state: " + str(state))
	if state is State:
		if current_state:
			current_state.exit_state()
		state.enter_state()
		current_state = state
	else:
		push_warning("You are trying to change state to something that is not a state")

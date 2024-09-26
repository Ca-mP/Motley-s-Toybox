extends Node
class_name StateMachine

@export var starting_state: State
var current_state

func _ready() -> void:
	change_state(starting_state)

func change_state(state):
	if state is State:
		if current_state:
			print("old state: " + str(current_state))
		if current_state:
			current_state.exit_state()
		state.enter_state()
		
		current_state = state
		print("new state: " + str(current_state))
		print()
	else:
		push_warning("You are trying to change state to something that is not a state")
	

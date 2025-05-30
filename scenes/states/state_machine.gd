extends Node
class_name StateMachine

@export var starting_state: State
var current_state: State

func _ready() -> void:
	change_state(starting_state)

func change_state(state: State):
	if current_state:
		current_state.exit_state()
		#if $"..".name != "Player":
		#print("old state: " + str(current_state))
	state.enter_state()
	current_state = state
	#if $"..".name != "Player":
	#print("new state: " + str(state))

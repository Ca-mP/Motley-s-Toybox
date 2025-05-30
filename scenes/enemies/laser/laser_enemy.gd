extends Enemy

@export var range_area: Area2D

@export var state_machine: StateMachine
@export_category("States")
@export var walk_state: State
@export var pause_state: State
@export var shoot_state: State
@export var death_state: State

var direction := 1

func _ready() -> void:
	pause_state.saw_player.connect(state_machine.change_state.bind(shoot_state))
	pause_state.no_player.connect(state_machine.change_state.bind(walk_state))
	
	walk_state.saw_player.connect(state_machine.change_state.bind(shoot_state))
	walk_state.no_player.connect(state_machine.change_state.bind(pause_state))
	
	shoot_state.attack_done.connect(state_machine.change_state.bind(pause_state))
	
	death_state.dead.connect(die)

func _process(delta: float) -> void:
	super(delta)
	if health <= 0:
		state_machine.change_state(death_state)
		
	if range_area.get_overlapping_bodies():
		player_in_range = true
	else:
		player_in_range = false
		
	if player_position < position:
		face_left()
		direction = -1
	if player_position > position:
		face_right()
		direction = 1

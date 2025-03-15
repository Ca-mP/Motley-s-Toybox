extends Enemy

@export var state_machine: StateMachine
@export var pause_state: State
@export var walk_state: State
@export var shock_state: State
@export var charge_state: State
@export var bonk_state: State
@export var death_state: State

@onready var raycast = $RayCast2D

func _ready() -> void:
	#connecting states
	pause_state.no_player.connect(state_machine.change_state.bind(walk_state))
	pause_state.saw_player.connect(state_machine.change_state.bind(shock_state))
	
	walk_state.no_player.connect(state_machine.change_state.bind(pause_state))
	walk_state.saw_player.connect(state_machine.change_state.bind(shock_state))
	
	shock_state.shock_done.connect(state_machine.change_state.bind(charge_state))
	
	charge_state.hit.connect(state_machine.change_state.bind(bonk_state))
	charge_state.charge_end.connect(state_machine.change_state.bind(pause_state))
	
	bonk_state.no_player.connect(change_random_walk_pause) #randomly chooses walk or pause
	bonk_state.saw_player.connect(state_machine.change_state.bind(charge_state))
	
	death_state.dead.connect(die)

func _process(_delta: float) -> void:
	
	#gravity
	velocity.y += 10
	if is_on_floor():
		velocity.y = 0
	
	#flipping sprite and atk area to correct direction
	if velocity.x < 0:
		face_left()
	elif velocity.x > 0:
		face_right()
	
	#setting raycast target to same x position as player
	raycast.target_position.x = player_position.x - position.x
	
	#checking if player is in range
	if raycast.get_collider():
		if raycast.get_collider().name == "Player":
			player_in_range = true
		else:
			player_in_range = false
	else:
		player_in_range = false
	
	#death
	if health <= 0 and state_machine.current_state != death_state:
		state_machine.change_state(death_state)
	
	apply_floor_snap()
	move_and_slide()

func change_random_walk_pause():
	var n = random_walk_pause()
	if n == "walk":
		state_machine.change_state(walk_state)
	elif n == "pause":
		state_machine.change_state(pause_state)

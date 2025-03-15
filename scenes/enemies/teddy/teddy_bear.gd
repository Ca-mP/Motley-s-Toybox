extends Enemy

@export_category("States")
@export var state_machine: StateMachine
@export var walk_state: State
@export var attack_state: State
@export var pause_state: State
@export var death_state: State

@onready var range_box = $RangeAreaPivot/RangeArea

var direction: int

func _ready() -> void:
	walk_state.no_player.connect(state_machine.change_state.bind(pause_state))
	walk_state.saw_player.connect(state_machine.change_state.bind(attack_state))
	
	attack_state.attack_done.connect(change_random_walk_pause) #randomly chooses walk or pause
	
	pause_state.no_player.connect(state_machine.change_state.bind(walk_state))
	pause_state.saw_player.connect(state_machine.change_state.bind(attack_state))
	
	death_state.dead.connect(die)

func _process(delta: float) -> void:
	super(delta)
	#gravity
	velocity.y += 10
	if is_on_floor():
		velocity.y = 0
	
	#facing range area correct way
	if player_position.x < global_position.x:
		$RangeAreaPivot.scale.x = 1
		direction = 1
		
		if $Sprite2D.scale.x > 0:
			$Sprite2D.scale.x *= -1
			
	else:
		$RangeAreaPivot.scale.x = -1
		direction = -1
		
		if $Sprite2D.scale.x < 0:
			$Sprite2D.scale.x *= -1
	
	#checking if player is in range
	if range_box.get_overlapping_bodies():
		player_in_range = true
	else:
		player_in_range = false
	
	#death
	if health <= 0 and state_machine.current_state != death_state:
		state_machine.change_state(death_state)
	
	apply_floor_snap()

func change_random_walk_pause():
	var n = random_walk_pause()
	if n == "walk":
		state_machine.change_state(walk_state)
	elif n == "pause":
		state_machine.change_state(pause_state)

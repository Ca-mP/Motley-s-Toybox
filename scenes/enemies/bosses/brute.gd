extends Enemy

@onready var punch_range = $Pivot/RangeBoxes/PunchRange
@onready var charge_range = $Pivot/RangeBoxes/ChargeRange

@onready var state_machine = $StateMachine
@onready var pause_state = $StateMachine/EnemyPauseState
@onready var charge_state = $StateMachine/EnemyChargeState
@onready var bonk_state = $StateMachine/EnemyBonkState
@onready var attack_state = $StateMachine/EnemyMeleeAttackState
@onready var walk_state = $StateMachine/EnemyWalkState
@onready var jump_state = $StateMachine/EnemyJumpState
@onready var aerial_state = $StateMachine/EnemyAerialState
@onready var land_state = $StateMachine/EnemyLandState
@onready var death_state = $StateMachine/EnemyDeathState

@onready var parent = $".."

var player_in_punch_range := false
var player_in_charge_range := false

func _ready() -> void:
	if GameState.brute_boss_beaten:
		queue_free()
	
	pause_state.saw_player.connect(choose_attack)
	pause_state.no_player.connect(choose_movement)
	
	walk_state.saw_player.connect(choose_attack)
	walk_state.no_player.connect(choose_movement)
	
	attack_state.saw_player.connect(choose_attack)
	attack_state.no_player.connect(choose_movement)
	
	charge_state.hit.connect(state_machine.change_state.bind(bonk_state))
	charge_state.charge_end.connect(choose_movement)
	
	bonk_state.saw_player.connect(choose_attack)
	bonk_state.no_player.connect(choose_movement)
	
	jump_state.jump_over.connect(state_machine.change_state.bind(aerial_state))
	
	aerial_state.land.connect(state_machine.change_state.bind(land_state))
	
	land_state.land_over.connect(choose_movement)
	
	death_state.dead.connect(death)

func _process(delta: float) -> void:
	super(delta)
	if punch_range.get_overlapping_bodies() or charge_range.get_overlapping_bodies():
		player_in_range = true
	else:
		player_in_range = false
		
	if punch_range.get_overlapping_bodies():
		print(punch_range.get_overlapping_bodies()[0].name)
		player_in_punch_range = true
	else:
		player_in_punch_range = false
	
	if charge_range.get_overlapping_bodies():
		player_in_charge_range = true
	else:
		player_in_charge_range = false
	
	if not is_on_floor():
		velocity.y += 2
	else:
		velocity.y = 0

func choose_attack():
	if player_in_punch_range:
		state_machine.change_state(attack_state)
	elif player_in_charge_range:
		state_machine.change_state(charge_state)
	else:
		state_machine.change_state(jump_state)

func choose_movement():
	var rand_i = randi_range(0, 2)
	match rand_i:
		0:
			state_machine.change_state(pause_state)
		1:
			state_machine.change_state(walk_state)
		2:
			state_machine.change_state(jump_state)
		_:
			state_machine.change_state(walk_state)

var gates_opened = false

func die():
	state_machine.change_state(death_state)
	if not gates_opened:
		parent.open_gates()
		gates_opened = true
	GameState.brute_boss_beaten = true

func death():
	queue_free()

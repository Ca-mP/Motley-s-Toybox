extends Enemy

@export_category("States")
@export var state_machine: StateMachine
@export var walk_state: State
@export var attack_state: State
@export var pause_state: State
@export var death_state: State

var direction: int

func _ready() -> void:
	walk_state.pause.connect(state_machine.change_state.bind(pause_state))
	walk_state.attack.connect(state_machine.change_state.bind(attack_state))
	walk_state.die.connect(state_machine.change_state.bind(death_state))
	
	attack_state.pause.connect(state_machine.change_state.bind(pause_state))
	attack_state.walk.connect(state_machine.change_state.bind(walk_state))
	attack_state.die.connect(state_machine.change_state.bind(death_state))
	
	pause_state.walk.connect(state_machine.change_state.bind(walk_state))
	pause_state.attack.connect(state_machine.change_state.bind(attack_state))
	pause_state.die.connect(state_machine.change_state.bind(death_state))
	
	death_state.dead.connect(die)

func _process(_delta: float) -> void:
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
	

	apply_floor_snap()
	move_and_slide()

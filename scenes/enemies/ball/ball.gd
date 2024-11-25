extends Enemy

@export var speed: int
@export var state_machine: StateMachine
@export var stupid_timer: Timer
@export_category("States")
@export var roll_state: State
@export var bounce_state: State
@export var death_state: State

@onready var timer = $Timer

var direction: int
var can_bounce: bool

func _ready() -> void:
	roll_state.bounce.connect(state_machine.change_state.bind(bounce_state))
	bounce_state.bounce_over.connect(state_machine.change_state.bind(roll_state))
	can_bounce = true
	direction = 1

func _process(delta: float) -> void:
	super(delta)

func bounce():
	can_bounce = false
	print("bounce")
	direction *= -1
	timer.start()         

func _on_timer_timeout() -> void:
	can_bounce = true

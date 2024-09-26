extends State
class_name EnemyWalkState

@export var actor: Enemy
@export var animator: AnimationPlayer
@export var range_box: Area2D
@export var walk_timer: Timer
@export var speed: int

signal attack
signal pause
signal die

var player_seen: bool

func _ready() -> void:
	set_physics_process(false)
	in_state = false
	walk_timer.timeout.connect(walk_timer_timeout)

func enter_state():
	set_physics_process(true)
	in_state = true
	walk_timer.start()
	
	#setting random direction to walk
	var direction_var = randi_range(0, 1)
	if direction_var == 0:
		speed *= -1

func _physics_process(_delta: float) -> void:
	animator.play("walk")
	actor.velocity.x = speed
	if actor.health <= 0 and in_state:
		die.emit()

func walk_timer_timeout():
	if range_box.get_overlapping_bodies() and in_state: #if player in range
		attack.emit()
	elif in_state:
		pause.emit()
	walk_timer.stop()

func exit_state():
	set_physics_process(false)
	in_state = false

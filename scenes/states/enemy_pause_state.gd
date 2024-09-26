extends State
class_name EnemyPauseState

@export var actor: Enemy
@export var animator: AnimationPlayer
@export var range_box: Area2D
@export var pause_timer: Timer

signal attack
signal walk
signal die

func _ready() -> void:
	set_physics_process(false)
	in_state = false
	pause_timer.timeout.connect(pause_timer_timeout)

func enter_state():
	set_physics_process(true)
	in_state = true
	pause_timer.start()
	animator.play("idle")

func _physics_process_(delta: float) -> void:
	actor.velocity.x = 0
	if actor.health <= 0 and in_state:
		die.emit()

func exit_state():
	set_physics_process(false)
	in_state = false

func pause_timer_timeout():
	if range_box.get_overlapping_bodies() and in_state: #if player in range
		attack.emit()
	elif in_state:
		walk.emit()
	pause_timer.stop()

extends State
class_name EnemyPauseState

@export var actor: Enemy
@export var animator: AnimationPlayer
@export var pause_timer: Timer

signal saw_player
signal no_player


func _ready() -> void:
	set_physics_process(false)
	pause_timer.timeout.connect(pause_timer_timeout)

func enter_state():
	set_physics_process(true)
	pause_timer.start()
	actor.velocity.x = 0
	animator.play("idle")

func _physics_process(delta: float) -> void:
	actor.velocity.x = move_toward(actor.velocity.x, 0, delta * 0.1)

func exit_state():
	pause_timer.stop()
	set_physics_process(false)

func pause_timer_timeout():
	if actor.player_in_range: #if player in range
		saw_player.emit()
	else:
		no_player.emit()

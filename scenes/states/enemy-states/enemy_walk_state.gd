extends State
class_name EnemyWalkState

@export var actor: Enemy
@export var animator: AnimationPlayer
@export var walk_timer: Timer
@export var speed: int

signal saw_player
signal no_player

var player_seen: bool
var direction_var

func _ready() -> void:
	set_physics_process(false)
	in_state = false
	walk_timer.timeout.connect(walk_timer_timeout)

func enter_state():
	in_state = true
	await get_tree().process_frame
	walk_timer.start()
	#setting random direction to walk
	direction_var = randi_range(0, 1)
	if direction_var == 0:
		speed *= -1
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	animator.play("walk")
	if walk_timer.wait_time == 0:
		walk_timer.start()
	
	if (speed > 0 and actor.ground_on_right) or (speed < 0 and actor.ground_on_left):
		actor.velocity.x = speed
	else:
		actor.velocity.x = 0


func walk_timer_timeout():
	if  actor.player_in_range and in_state:
		saw_player.emit()
	else:
		no_player.emit()
	walk_timer.stop()

func exit_state():
	set_physics_process(false)
	walk_timer.stop()
	in_state = false

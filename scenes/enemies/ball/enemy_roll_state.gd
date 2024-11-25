extends State

@export var actor: Enemy
@export var animator: AnimationPlayer
@export var speed: int

signal bounce

func _ready() -> void:
	set_physics_process(false)

func enter_state():
	set_physics_process(true)
	animator.play("roll")

func _physics_process(_delta: float) -> void:
	actor.velocity.x = speed * actor.direction
	if actor.is_on_wall() and actor.can_bounce:
		bounce.emit()
		actor.can_bounce = false

func exit_state():
	set_physics_process(false)

func _on_timer_timeout() -> void:
	actor.can_bounce = true

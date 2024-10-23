extends PlayerState
class_name PlayerJumpState

@export var jump_timer: Timer

@export var jump_velocity: int

signal fall
signal cast

func _ready() -> void:
	super()
	jump_timer.timeout.connect(on_jump_timer_timeout)

func enter_state():
	super()
	jump_timer.start()
	animator.play("jump")

func _physics_process(_delta: float) -> void:
	actor.velocity.y = -jump_velocity
	
	if Input.is_action_just_released("jump"):
		fall.emit()
	if Input.is_action_pressed("spell") and actor.equipped_material.current:
		cast.emit()

func on_jump_timer_timeout():
	fall.emit()

func exit_state():
	super()
	jump_timer.stop()

extends PlayerState
class_name PlayerWalkState

signal idle
signal jump
signal cast
signal fall

func _ready() -> void:
	super()

func enter_state():
	super()
	animator.play("walk")

func _physics_process(_delta: float) -> void:
	if actor.velocity.y > 0:
		fall.emit()
	if actor.velocity.x == 0 and actor.direction == 0:
		idle.emit()
	if Input.is_action_pressed("jump"):
		jump.emit()
	if Input.is_action_just_pressed("spell") and actor.equipped_material.current:
		cast.emit()

func exit_state():
	super()

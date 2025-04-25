extends PlayerState
class_name PlayerDoneCastState

signal idle
signal walk
signal jump
signal fall

func _ready() -> void:
	super()

func enter_state():
	super()
	actor.can_move = true

func _physics_process(_delta: float) -> void:
	if actor.velocity.y > 0:
		fall.emit()
	elif actor.velocity.x == 0:
		idle.emit()
	elif Input.is_action_pressed("jump"):
		jump.emit()
	elif actor.velocity.x:
		walk.emit()

func exit_state():
	super()

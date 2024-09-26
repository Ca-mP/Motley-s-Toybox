extends PlayerState
class_name PlayerFallState

signal land
signal cast

func _ready() -> void:
	super()

func enter_state():
	super()
	animator.play("fall")
	actor.velocity.y /= 3

func _physics_process(_delta: float) -> void:
	if actor.is_on_floor():
		land.emit()
	if Input.is_action_pressed("spell") and actor.material_equipped_amount:
		cast.emit()

func exit_state():
	super()

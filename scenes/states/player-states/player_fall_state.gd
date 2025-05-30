extends PlayerState
class_name PlayerFallState

signal land
signal cast

func _ready() -> void:
	super()
	animator.animation_finished.connect(animation_finished)

func enter_state():
	super()
	animator.play("jump_to_fall")
	if actor.velocity.y < 0:
		actor.velocity.y /= 3
		actor.velocity.y += 30

func _physics_process(_delta: float) -> void:
	if actor.is_on_floor():
		land.emit()
	if Input.is_action_just_pressed("spell") and actor.equipped_material.current:
		cast.emit()

func animation_finished(anim_name):
	if anim_name == "jump_to_fall":
		animator.play("fall")

func exit_state():
	super()

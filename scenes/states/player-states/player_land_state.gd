extends PlayerState
class_name PlayerLandState

signal idle
signal walk
signal jump
signal fall
signal cast

var animation_finished: bool

func _ready() -> void:
	super()
	animator.animation_finished.connect(on_animation_finished)
	animation_finished = false

func enter_state():
	super()
	sfx.pitch_scale = randf_range(0.8, 1.2)
	sfx.play()
	animator.play("land")
	animation_finished = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("spell") and actor.equipped_material.current:
		cast.emit()
	elif actor.velocity.y > 0:
		fall.emit()
	elif actor.velocity.x == 0 and not animation_finished:
		idle.emit()
	elif Input.is_action_pressed("jump"):
		jump.emit()
	elif actor.velocity.x and not animation_finished:
		walk.emit()

func exit_state():
	super()

func on_animation_finished(anim_name):
	if anim_name == "land":
		animation_finished = true

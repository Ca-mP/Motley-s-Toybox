extends PlayerState
class_name PlayerStunState

signal end_stun
signal die

func _ready() -> void:
	set_physics_process(false)
	animator.animation_finished.connect(on_animation_finished)

func enter_state():
	set_physics_process(true)
	actor.velocity /= 4
	animator.play("stun")

func _physics_process(_delta: float) -> void:
	actor.stunned = true

func exit_state():
	set_physics_process(false)
	actor.stunned = false

func on_animation_finished(anim_name):
	if anim_name == "stun":
		if actor.current_health <= 0:
			die.emit()
		else:
			end_stun.emit()

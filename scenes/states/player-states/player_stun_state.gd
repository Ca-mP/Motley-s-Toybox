extends PlayerState
class_name PlayerStunState

signal end_stun
signal die

var direction
var knockback_speed

func _ready() -> void:
	set_physics_process(false)
	animator.animation_finished.connect(on_animation_finished)
	direction = 1

func enter_state():
	knockback_speed = 3000
	actor.set_collision_mask_value(3, false)
	actor.set_collision_layer_value(1, false)
	set_physics_process(true)
	actor.velocity /= 4
	animator.play("stun")

func _physics_process(delta: float) -> void:
	actor.stunned = true
	actor.velocity.x = -direction * knockback_speed * delta
	knockback_speed -= 10

func exit_state():
	set_physics_process(false)
	actor.set_collision_mask_value(3, true)
	actor.set_collision_layer_value(1, true)
	actor.stunned = false

func on_animation_finished(anim_name):
	if anim_name == "stun":
		if actor.current_health <= 0:
			die.emit()
		else:
			end_stun.emit()

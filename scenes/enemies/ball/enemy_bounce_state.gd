extends EnemyState

signal bounce_over

func _ready() -> void:
	super()
	in_state = false
	animator.animation_finished.connect(on_animation_finished)

func enter_state():
	super()
	in_state = true
	animator.play("bounce")
	actor.bounce()

func exit_state():
	super()
	in_state = false

func on_animation_finished(anim_name):
	if anim_name == "bounce" and in_state:
		bounce_over.emit()

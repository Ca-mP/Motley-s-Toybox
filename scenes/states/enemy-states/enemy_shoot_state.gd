extends EnemyState

func _ready() -> void:
	set_physics_process(false)
	animator.animation_finished.connect(animation_finished)

func enter_state():
	set_physics_process(true)
	animator.play("shoot")

func _physics_process(delta: float) -> void:
	pass

func exit_state():
	set_physics_process(false)

func animation_finished(anim_name):
	if anim_name == "shoot":
		pass

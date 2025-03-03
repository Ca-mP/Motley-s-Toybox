extends EnemyState

signal jump_over

func _ready() -> void:
	super()
	animator.connect("animation_finished", on_animation_finished)
	set_physics_process(false)

func enter_state():
	super()
	set_physics_process(true)
	animator.play("jump1")

func _physics_process(_delta: float) -> void:
	actor.velocity.x += 4 * actor.direction_to_player

func exit_state():
	super()
	set_physics_process(false)

func on_animation_finished(anim_name):
	if anim_name == "jump1":
		animator.play("jump2")
		actor.velocity.y = -300
	if anim_name == "jump2":
		jump_over.emit()

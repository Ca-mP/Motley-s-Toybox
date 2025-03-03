extends EnemyState

signal land_over

@export var left_particles: CPUParticles2D
@export var right_particles: CPUParticles2D

func _ready() -> void:
	super()
	animator.animation_finished.connect(on_animation_finished)

func enter_state():
	super()
	animator.play("land")
	left_particles.emitting = true
	right_particles.emitting = true

func _physics_process(_delta: float) -> void:
	pass

func exit_state():
	super()

func on_animation_finished(anim_name):
	if anim_name == "land":
		land_over.emit()

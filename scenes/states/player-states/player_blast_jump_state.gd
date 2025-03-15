extends PlayerState

@export var explosion_scene: PackedScene
@export var jump_velocity: int
@export var particles: CPUParticles2D

signal done

var has_jumped: bool

func _ready() -> void:
	super()
	animator.animation_finished.connect(on_animation_finished)

func enter_state():
	super()
	has_jumped = false
	
	animator.play("blast_jump")
	
	actor.fire_material.current -= 1
	actor.equipped_material.current -= 1
	

func _physics_process(_delta: float) -> void:
	if actor.velocity.y < 0:
		particles.emitting = true
	else:
		particles.emitting = false
	
	if actor.velocity.y >= 0 and has_jumped:
		done.emit()
		particles.emitting = false

func exit_state():
	super()
	particles.emitting = false

func on_animation_finished(anim_name):
	if anim_name == "blast_jump":
		var explosion = explosion_scene.instantiate()
		explosion.original_position = actor.position
		
		actor.velocity.y = -jump_velocity
		
		self.add_child(explosion)
		explosion.go_to_root()
		
		has_jumped = true
		actor.has_blast_jumped = true
		actor.pass_player_info()

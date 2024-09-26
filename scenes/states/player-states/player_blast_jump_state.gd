extends PlayerState

@export var explosion_scene: PackedScene
@export var jump_velocity: int

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
	actor.material_equipped_amount -= 1
	

func _physics_process(delta: float) -> void:
	if actor.velocity.y >= 0 and has_jumped:
		done.emit()

func exit_state():
	super()

func on_animation_finished(anim_name):
	if anim_name == "blast_jump":
		var explosion = explosion_scene.instantiate()
		actor.velocity.y = -jump_velocity
		actor.call_deferred("add_child", explosion)
		has_jumped = true

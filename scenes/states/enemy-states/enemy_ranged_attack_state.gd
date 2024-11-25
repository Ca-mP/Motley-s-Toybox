extends State
class_name EnemyRangedAttackState

@export var actor: Enemy
@export var animator: AnimationPlayer
@export var projectile_scene: PackedScene

signal attack_done

func _ready() -> void:
	set_physics_process(false)
	in_state = false
	animator.animation_finished.connect(_on_animation_player_animation_finished)

func enter_state():
	set_physics_process(true)
	in_state = true
	actor.velocity.x = 0
	animator.play("attack")

func exit_state():
	set_physics_process(false)
	in_state = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("animation over")
	if anim_name == "attack" and in_state:
		throw_projectile()
		animator.play("attack2")
	
	if anim_name == "attack2":
		attack_done.emit()

func throw_projectile():
	var projectile = projectile_scene.instantiate()
	projectile.direction = actor.direction
	projectile.original_position = actor.position
	self.add_child(projectile)

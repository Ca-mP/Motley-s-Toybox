extends EnemyState
class_name EnemyMeleeAttackState

@export var attack_box: Area2D
@export var damage: int

signal saw_player
signal no_player

func _ready() -> void:
	super()
	set_physics_process(false)
	animator.animation_finished.connect(on_animation_finished)

func enter_state():
	super()
	set_physics_process(true)
	actor.velocity = Vector2.ZERO
	animator.play("melee_attack")

func _physics_process(_delta: float) -> void:
	if attack_box.monitoring:
		if attack_box.get_overlapping_bodies():
			if "hit" in attack_box.get_overlapping_bodies()[0]:
				attack_box.get_overlapping_bodies()[0].hit(damage, -actor.pivot.scale.x)
	

func exit_state():
	super()
	set_physics_process(false)

func on_animation_finished(anim_name):
	if anim_name == "melee_attack":
		if actor.player_in_range:
			saw_player.emit()
		else:
			no_player.emit()

extends State
class_name EnemyDeathState

@export var actor: Enemy
@export var animator: AnimationPlayer

signal dead

func _ready() -> void:
	set_physics_process(false)
	animator.animation_finished.connect(animation_finished)

func enter_state():
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	actor.set_collision_layer_value(3, false)
	actor.set_collision_mask_value(1, false)
	actor.set_collision_mask_value(4, false)
	actor.velocity = Vector2.ZERO
	animator.play("death")

func exit_state():
	set_physics_process(false)

func animation_finished(anim_name):
	if anim_name == "death":
		dead.emit()
		print("die")

extends StaticBody2D
class_name Gate

@export var animator: AnimationPlayer
@export var collision_shape: CollisionShape2D

func _ready() -> void:
	animator.animation_finished.connect(on_animation_finished)
	print(collision_shape)

func open():
	animator.play("open")

func opened():
	animator.play("opened");

func close():
	animator.play("close");

func closed():
	animator.play("closed");

func on_animation_finished(anim_name):
	if anim_name == "close" or anim_name == "closed":
		collision_shape.set_deferred("disabled", false)
	if anim_name == "open" or anim_name == "opened":
		collision_shape.set_deferred("disabled", true)

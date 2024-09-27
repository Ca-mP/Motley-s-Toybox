extends Area2D
class_name Explosion

@export var damage: int
@export var area: Area2D
@export var animator: AnimatedSprite2D


func _ready() -> void:
	animator.play("default")
	
	area.body_entered.connect(on_body_entered)
	animator.animation_finished.connect(animation_finished)

func on_body_entered(body):
	if "hit" in body:
		body.hit(damage)
	if "burn" in body:
		body.burn()

func animation_finished():
	if "end" in $"..":
		$"..".end()
	queue_free()

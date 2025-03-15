extends StaticBody2D

func _ready() -> void:
	$CollisionShape2D.disabled = false

func burn():
	$AnimatedSprite2D.play("crumble")

func _on_animated_sprite_2d_animation_finished() -> void:
	$CollisionShape2D.disabled = true

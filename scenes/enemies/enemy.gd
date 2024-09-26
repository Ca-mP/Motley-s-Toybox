extends CharacterBody2D
class_name Enemy

@export var health: int
@export var damage: int
@export var has_projectile: int
@export var projectile: Area2D
@export var player_position := Vector2.ZERO

func hit(dmg):
	health -= dmg

func die():
	queue_free()

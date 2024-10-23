extends CharacterBody2D
class_name Enemy

@export var health: int
@export var damage: int
@export var attack_type: String #ranged, melee, special
@export var pivot: Node2D
@export var player_position := Vector2.ZERO
@export var left_feeler: RayCast2D
@export var right_feeler: RayCast2D

@onready var player_in_range

var ground_on_left: bool
var ground_on_right: bool

func _process(_delta: float) -> void:
	if left_feeler.is_colliding():
		ground_on_left = true
	else:
		ground_on_left = false
	
	if right_feeler.is_colliding():
		ground_on_right = true
	else:
		ground_on_right = false

func hit(dmg):
	health -= dmg

func die():
	queue_free()

func face_left():
	pivot.scale.x = -1

func face_right():
	pivot.scale.x = 1

func random_walk_pause():
	var r = randi_range(0, 1)
	if r == 0:
		return "walk"
	elif r == 1:
		return "pause"

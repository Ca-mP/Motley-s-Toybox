extends CharacterBody2D
class_name Enemy

@export var health: int
@export var damage: int
@export var pivot: Node2D
@export var player_position := Vector2.ZERO
@export var left_feeler: RayCast2D
@export var right_feeler: RayCast2D
@export var faces_player: bool
@export var falls: bool

@onready var player_in_range

var direction_to_player: int
var ground_on_left := true
var ground_on_right := true

func _ready() -> void:
	set_physics_process(false)

func enter_state():
	set_physics_process(true)

func _process(_delta: float) -> void:
	if left_feeler.is_colliding():
		ground_on_left = true
	elif not falls:
		ground_on_left = false
	
	if right_feeler.is_colliding():
		ground_on_right = true
	elif not falls:
		ground_on_right = false
		
		if player_position.x > global_position.x:
			direction_to_player = 1
			if faces_player:
				face_right()
		elif player_position.x < global_position.x:
			direction_to_player = -1
			if faces_player:
				face_left()
		
	if health <= 0:
		die()
	move_and_slide()

func exit_state():
	set_physics_process(false)

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

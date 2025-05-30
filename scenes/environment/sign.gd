extends Area2D

@onready var sign_face = $SignFace
@onready var sign_text = $SignFace/RichTextLabel

@export var text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sign_face.modulate = Color(1, 1, 1, 0)
	sign_text.text = "[center] " + text + "[/center]"

var player_near := false

func _process(delta: float) -> void:
	if get_overlapping_bodies():
		var player = get_overlapping_bodies()[0]
		player_near = true
	else:
		player_near = false
	
	if player_near:
		sign_face.modulate.a += 0.01
		clamp(sign_face.modulate.a, 0, 1)
		sign_face.position = sign_face.position.lerp(Vector2(-2, -85), delta * 2)
		sign_face.scale = sign_face.scale.lerp(Vector2(0.055, 0.063), delta * 2)
	else:
		sign_face.modulate.a -= 0.005
		sign_face.position = sign_face.position.lerp(Vector2(-1, -20), delta * 2)
		sign_face.scale = sign_face.scale.lerp(Vector2(0.022, 0.031), delta * 2)

	if sign_face.modulate.a < 0:
		sign_face.modulate.a = 0
	if sign_face.modulate.a > 1:
		sign_face.modulate.a = 1

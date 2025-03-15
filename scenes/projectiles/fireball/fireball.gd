extends Area2D

@onready var direction: Vector2

@export var explosion_scene: PackedScene
@export var speed: int
@export var damage: int

@onready var original_position: Vector2

var exploding: bool

func _ready() -> void:
	exploding = false
	original_position.y -= 35
	rotation = direction.angle()

func _process(delta: float) -> void:
	if not exploding:
		position += direction.normalized() * speed * delta

func go_to_root():
	var parent = self.get_parent()
	while parent.get_parent() and parent.name != "Level":
		parent.remove_child(self)
		parent.get_parent().add_child(self)
		parent = self.get_parent()
	position = original_position

func _on_body_entered(_body: Node2D) -> void:
	explode()

func explode():
	exploding = true
	var explosion = explosion_scene.instantiate()
	self.call_deferred("add_child", explosion)
	$AnimatedSprite2D.visible = false

func end():
	queue_free()

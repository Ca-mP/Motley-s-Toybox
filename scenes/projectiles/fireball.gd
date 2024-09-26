extends Area2D

@onready var direction: Vector2

@export var speed: int
@export var damage: int

@onready var original_position: Vector2

func _ready() -> void:
	original_position.y -= 35
	rotation = direction.angle()

func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta

func go_to_root():
	var parent = self.get_parent()
	while parent.get_parent() and parent.name != "Level":
		parent.remove_child(self)
		parent.get_parent().add_child(self)
		parent = self.get_parent()
	position = original_position

func _on_body_entered(body: Node2D) -> void:
	if "hit" in body:
		body.hit(damage)
	if not body.name == "Player":
		queue_free()

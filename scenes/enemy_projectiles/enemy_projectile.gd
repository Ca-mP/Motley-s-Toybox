extends Area2D
class_name EnemyProjectile

@export var area: Area2D
@export var starting_velocity: Vector2
@export var direction: int
@export var speed: int
@export var projectile_gravity: float
@export var damage: int

@onready var original_position: Vector2
var velocity: Vector2

func _ready() -> void:
	go_to_root()
	starting_velocity.x *= direction
	velocity = starting_velocity
	area.body_entered.connect(on_body_entered)

func _process(delta: float) -> void:
	velocity.y += projectile_gravity
	position += velocity * speed * delta

func go_to_root():
	var parent = self.get_parent()
	while parent.get_parent() and parent.name != "Level":
		parent.remove_child(self)
		parent.get_parent().add_child(self)
		parent = self.get_parent()
	position = original_position

func on_body_entered(body: Node2D) -> void:
	if "hit" in body:
		body.hit(damage, direction)
	queue_free()

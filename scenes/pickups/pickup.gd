extends Node2D
class_name Pickups

@export var type: String
@export var quantity: int
@export var area: Area2D

func _ready():
	area.body_entered.connect(body_entered)

func body_entered(body):
	if "pickup" in body:
		body.pickup(type, quantity)
		queue_free()

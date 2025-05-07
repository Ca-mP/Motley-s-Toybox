extends AnimatedSprite2D

@onready var timer = $Timer
@onready var area = $Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(on_timeout)
	play("default")
	if area.get_overlapping_bodies():
		var bodies =  area.get_overlapping_bodies()
		for body in bodies:
			if "hit" in body:
				body.hit(1)

func on_timeout():
	queue_free()

extends Area2D

@export var dmg: int

@onready var sprite := $AnimatedSprite2D
@onready var dmg_timer := $DmgTimer
@onready var direction: int

var original_position:Vector2
var can_dmg := true

func _ready() -> void:
	dmg_timer.timeout.connect(on_dmg_timeout)
	sprite.animation_finished.connect(on_animation_finished)
	sprite.play("enter")
	
	#putting at player's hands
	original_position.y -= 35
	original_position.x  += 38 * direction
	scale.x = direction * 0.3

func _process(delta: float) -> void:
	#doing dmg
	print(get_overlapping_bodies())
	if get_overlapping_bodies():
		for body in get_overlapping_bodies():
			if "hit" in body and can_dmg:
				body.hit(dmg)
				can_dmg = false
				dmg_timer.start()

func go_to_root():
	var parent = self.get_parent()
	while parent.get_parent() and parent.name != "Level":
		parent.remove_child(self)
		parent.get_parent().add_child(self)
		parent = self.get_parent()
	position = original_position

func on_animation_finished():
	if sprite.animation == "enter":
		sprite.play("default")
	elif sprite.animation == "leave":
		queue_free()

func on_dmg_timeout():
	can_dmg = true

func exit():
	sprite.play("leave")

extends PlayerState
class_name PlayerFireballState

signal done

var fireball_scene = preload("res://scenes/projectiles/fireball.tscn")

func _ready() -> void:
	super()
	animator.animation_finished.connect(on_animation_finished)

func enter_state():
	super()
	animator.play("spell")
	
	var fireball_instance = fireball_scene.instantiate()
	
	fireball_instance.original_position = actor.position
	fireball_instance.direction = actor.aim_direction
	
	self.add_child(fireball_instance)
	fireball_instance.go_to_root()
	
	actor.fire_material.current -= 1
	actor.material_equipped_amount -= 1
	
	actor.pass_player_info()

func on_animation_finished(anim_name):
	if anim_name == "spell":
		done.emit()

func exit_state():
	super()

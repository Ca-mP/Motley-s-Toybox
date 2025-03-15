extends PlayerState

signal done

var fireball_scene = preload("res://scenes/projectiles/fireball/fireball.tscn")

@export var fireball_timer: Timer
@export var particles: CPUParticles2D

func _ready() -> void:
	super()
	fireball_timer.timeout.connect(on_timeout)
	in_state = false

func enter_state():
	super()
	in_state = true
	animator.play("spell")
	fireball_timer.start()
	
	var fireball_instance = fireball_scene.instantiate()
	
	fireball_instance.original_position = actor.position
	fireball_instance.direction = actor.aim_direction
	
	self.add_child(fireball_instance)
	fireball_instance.go_to_root()
	particles.emitting = true
	
	actor.fire_material.current -= 1
	actor.equipped_material.current -= 1
	
	actor.pass_player_info()

func on_timeout():
	if in_state:
		done.emit()
	else:
		fireball_timer.stop()

func exit_state():
	super()
	in_state = false

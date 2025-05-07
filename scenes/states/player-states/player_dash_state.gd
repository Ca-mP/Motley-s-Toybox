extends PlayerState
class_name PlayerDashState

signal done

@export var speed: int
@export var sfx2: AudioStreamPlayer
@export var particles: CPUParticles2D

@onready var timer = $DashTimer
@onready var effect_timer = $EffectTimer

var dash_effect_scene = preload("res://scenes/player/dash_effect.tscn")

func _ready() -> void:
	super()
	timer.timeout.connect(on_timeout)
	effect_timer.timeout.connect(create_effect)

func enter_state():
	super()
	in_state = true
	
	timer.start()
	effect_timer.start()
	animator.play("dash")
	
	sfx.play()
	
	actor.lightning_material.current -= 1
	actor.equipped_material.current -= 1
	actor.pass_player_info()
	
	actor.set_collision_mask_value(3, false)
	
	actor.velocity.x = speed * actor.aim_direction
	actor.glide_direction = actor.aim_direction
	
	actor.gliding = true
	actor.can_move = false

func _physics_process(_delta: float) -> void:
	actor.velocity.y = 0

func on_timeout():
	actor.can_move = true
	done.emit()

func create_effect():
	if in_state:
		var dash_effect = dash_effect_scene.instantiate()
		dash_effect.position = actor.position
		dash_effect.position.y -= 45
		actor.add_sibling(dash_effect)
		effect_timer.start()

func exit_state():
	super()
	particles.emitting = true
	in_state = false

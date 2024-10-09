extends State
class_name EnemyChargeState

@export var actor: Enemy
@export var animator: AnimationPlayer
@export var atk_area: Area2D
@export var stupid_timer: Timer
@export var charge_speed: int

signal hit

var direction: int
var can_hit_wall: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	stupid_timer.timeout.connect(on_stupid_timer_timeout)

func enter_state():
	animator.play("charge")
	
	#setting direction to charge in
	if actor.position.x - actor.player_position.x < 0:
		direction = 1
	else:
		direction = -1
	
	can_hit_wall = false
	stupid_timer.start()
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	actor.velocity.x = charge_speed * direction
	
	if atk_area.get_overlapping_bodies() and can_hit_wall:
		hit.emit()
		if "hit" in atk_area.get_overlapping_bodies()[0]:
			atk_area.get_overlapping_bodies()[0].hit(actor.damage)

func exit_state():
	can_hit_wall = false
	set_physics_process(false)

func on_stupid_timer_timeout():
	can_hit_wall = true

extends State
class_name EnemyShockState

@export var actor: Enemy
@export var animator: AnimationPlayer
@export var sprite: Sprite2D

signal shock_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	animator.connect("animation_finished", on_animation_finished)

func enter_state():
	set_physics_process(true)
	
	#facing enemy to direction of player
	if actor.position.x < actor.player_position.x:
		actor.face_right()
	elif actor.position.x > actor.player_position.x:
		actor.face_left()
		
	animator.play("shock")

func _physics_process(_delta: float) -> void:
	actor.velocity.x = 0

func exit_state():
	set_physics_process(false)

func on_animation_finished(anim_name):
	if anim_name == "shock":
		shock_done.emit()

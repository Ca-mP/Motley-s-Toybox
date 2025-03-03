extends State
class_name EnemyBonkState

@export var actor: Enemy
@export var animator: AnimationPlayer

signal saw_player
signal no_player

func _ready() -> void:
	set_physics_process(false)
	animator.connect("animation_finished", on_animation_finished)

func enter_state():
	set_physics_process(true)
	animator.play("bonk")

func _physics_process(_delta: float) -> void:
	actor.velocity.x = 0

func exit_state():
	if actor.position.x - actor.player_position.x < 0:
		actor.face_right()
	else:
		actor.face_left()
	set_physics_process(false)

func on_animation_finished(anim_name):
	if anim_name == "bonk":
		if actor.player_in_range:
			saw_player.emit()
		else:
			no_player.emit()

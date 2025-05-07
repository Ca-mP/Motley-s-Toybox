extends PlayerState

signal done

var lightning_blast_scene = preload("res://scenes/projectiles/thunder_blast.tscn")

func _ready() -> void:
	super()
	in_state = false
	animator.animation_finished.connect(anim_finished)

func enter_state():
	super()
	in_state = true
	animator.play("lightning_blast_intro")

func _physics_process(_delta: float) -> void:
	actor.can_move = false
	actor.velocity = Vector2.ZERO
	if not Input.is_action_pressed("spell") and in_state:
		done.emit()

var lightning_blast_instance

func exit_state():
	super()
	in_state = false
	if is_instance_valid(lightning_blast_instance):
		lightning_blast_instance.exit()

func anim_finished(anim_name):
	if in_state and anim_name == "lightning_blast_intro":
		lightning_blast_instance = lightning_blast_scene.instantiate()
		
		lightning_blast_instance.original_position = actor.position
		lightning_blast_instance.direction = actor.aim_direction
		
		self.add_child(lightning_blast_instance)
		lightning_blast_instance.go_to_root()
		
		actor.lightning_material.current -= 1
		actor.equipped_material.current -= 1
		
		animator.play("lightning_blast")
		actor.pass_player_info()

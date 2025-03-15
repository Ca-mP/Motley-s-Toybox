extends PlayerState
class_name PlayerIdleState

signal walk
signal jump
signal cast

func _ready() -> void:
	super()

func enter_state():
	super()
	animator.play("idle")

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("jump"):
		jump.emit()
	if actor.velocity.x:
		walk.emit()
	if Input.is_action_pressed("spell") and actor.equipped_material.current:
		cast.emit()


func exit_state():
	super()

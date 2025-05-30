extends State
class_name PlayerState

@export var actor: CharacterBody2D
@export var animator: AnimationPlayer
@export var sfx: AudioStreamPlayer

func _ready() -> void:
	set_physics_process(false)

func enter_state():
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	pass

func exit_state():
	set_physics_process(false)

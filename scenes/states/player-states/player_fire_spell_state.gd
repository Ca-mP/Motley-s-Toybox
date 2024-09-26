extends PlayerState
class_name PlayerFireSpellState

signal fireball
signal blast_jump

func _ready() -> void:
	super()

func enter_state():
	super()

func _physics_process(delta: float) -> void:
	if actor.spell_mode == "attack":
		fireball.emit()
	elif actor.spell_mode == "utility":
		blast_jump.emit()

func exit_state():
	super()

extends PlayerState
class_name PlayerFireSpellState

signal fireball
signal blast_jump
signal done

func _ready() -> void:
	super()

func enter_state():
	super()

func _physics_process(_delta: float) -> void:
	if actor.spell_mode == "attack":
		fireball.emit()
	elif actor.spell_mode == "utility":
		if actor.has_blast_jumped:
			done.emit()
		else:
			blast_jump.emit()

func exit_state():
	super()

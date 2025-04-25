extends PlayerState
class_name PlayerLightningSpellState

signal lightning_blast
signal dash
signal done

func _ready() -> void:
	super()

func enter_state():
	super()

func _physics_process(_delta: float) -> void:
	if actor.spell_mode == "attack":
		lightning_blast.emit()
	elif actor.spell_mode == "utility":
		if actor.has_blast_jumped:
			done.emit()
		else:
			dash.emit()

func exit_state():
	super()

extends PlayerState
class_name PlayerCastState

signal fire_spell
signal lightning_spell
signal water_spell
signal no_spell

func _ready() -> void:
	super()

func enter_state():
	super()

func _physics_process(_delta: float) -> void:
	if actor.material_equipped_amount:
		if actor.material_equipped == "fire":
			fire_spell.emit()
		elif actor.material_equipped == "lightning":
			lightning_spell.emit()
		elif actor.material_equipped == "water":
			water_spell.emit()
	else:
		no_spell.emit()

func exit_state():
	super()

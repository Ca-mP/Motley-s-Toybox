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
	if actor.equipped_material.current:
		match actor.equipped_material.material:
			"fire":
				fire_spell.emit()
			"lightning":
				lightning_spell.emit()
			"water":
				water_spell.emit()
			_:
				no_spell.emit()


func exit_state():
	super()

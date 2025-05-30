extends HBoxContainer

@export var player: CharacterBody2D
@export var healthbar: ProgressBar
@export var material_counter: Label

func _process(delta: float) -> void:
	#updating health bar
	healthbar.max_value = player.max_health
	healthbar.value = player.current_health
	
	material_counter.text = str(player.material_equipped_amount)

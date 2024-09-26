extends CanvasLayer

@export var player_max_health: int
@export var player_current_health: int
@export var player_material_equipped: String
@export var player_current_materials: int

@export var healthbar: ProgressBar
@export var material_icon: TextureRect
@export var material_counter: Label

var fire_icon = preload("res://sprites/ui/FireballUI.png")

func update():
	healthbar.max_value = player_max_health
	healthbar.value = player_current_health
	
	#get material icons and update the material icon
	if player_material_equipped == "fire":
		$TopBar/Materials/MaterialIcon.texture = fire_icon
	
	material_counter.text = str(player_current_materials)
	

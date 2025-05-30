extends CanvasLayer
class_name GameUI

@export var player_max_health: int
@export var player_current_health: int
@export var player_material_equipped: String
@export var player_current_materials: int

@export var healthbar: ProgressBar
@export var material_icon: TextureRect
@export var material_counter: Label

var fire_icon = preload("res://sprites/ui/FireballUI.png")
var lightning_icon = preload("res://sprites/ui/LightningUI.png")

func update():
	healthbar.max_value = player_max_health
	healthbar.value = player_current_health
	
	#get material icons and update the material icon
	if player_material_equipped == "fire":
		material_icon.texture = fire_icon
	elif player_material_equipped == "lightning":
		material_icon.texture = lightning_icon
	
	material_counter.text = str(player_current_materials)
	

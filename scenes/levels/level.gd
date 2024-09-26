extends Node2D
class_name Level

func _ready() -> void:
	pass_player_info($Player)

func _process(_delta: float) -> void:
	pass_player_position()

func pass_player_info(player):
	var ui = $UI
	
	ui.player_max_health = player.max_health
	ui.player_current_health = player.current_health
	ui.player_material_equipped = player.material_equipped
	ui.player_current_materials = player.material_equipped_amount
	
	ui.update()

func pass_player_position():
	$Enemies.pass_player_position($Player.get_global_position())

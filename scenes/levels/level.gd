extends Node2D
class_name Level

@onready var player = $Player
var save_path = "user://wizard-save-file.save"

func _ready() -> void:
	pass_player_info($Player)

func _process(_delta: float) -> void:
	pass_player_position()

func pass_player_info(_player):
	var ui = $UI
	
	ui.player_max_health = _player.max_health
	ui.player_current_health = _player.current_health
	ui.player_material_equipped = _player.material_equipped
	ui.player_current_materials = _player.material_equipped_amount
	
	ui.update()

func pass_player_position():
	$Enemies.pass_player_position($Player.get_global_position())

func save(save_area, save_id):
	var file = FileAccess.open(save_path, FileAccess.READ)
	
	#heal player and refill materials
	player.current_health = player.max_health
	
	if player.fire_material.unlocked:
		player.fire_material.current = player.fire_material.max
	if player.lightning_material.unlocked:
		player.lightning_material.current = player.lightning_material.max
	if player.water_material.unlocked:
		player.water_material.current = player.water_material.max
		
		#save room id
	var area = save_area
	var id = save_id
	
	file.store_var(area)
	file.store_var(id)
	
	#save player info
	var max_health = player.max_health
	var fire_unlocked = player.fire_material.unlocked
	var fire_max = player.fire_material.max
	var lightning_unlocked = player.lightning_material.unlocked
	var lightning_max = player.lightning_material.max
	var water_unlocked = player.water_material.unlocked
	var water_max = player.water_material.max
	
	file.store_var(max_health)
	file.store_var(fire_unlocked)
	file.store_var(fire_max)
	file.store_var(lightning_unlocked)
	file.store_var(lightning_max)
	file.store_var(water_unlocked)
	file.store_var(water_max)

func load_data():
	#set player info
	#put player in room according to id
	pass

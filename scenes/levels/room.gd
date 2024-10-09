extends Node2D
class_name Room

@export var player: Player
@export var enemies: LevelEnemies
@export var save_points: LevelSavePoints
@export var doors: LevelDoors
@export var ui: CanvasLayer

var save_path = "user://wizard-save-file.save"

var area
var id

var max_health
var fire_unlocked
var fire_max
var lightning_unlocked
var lightning_max
var water_unlocked
var water_max

func _ready() -> void:
	pass_player_info(player)

func _process(_delta: float) -> void:
	pass_player_position()

func pass_player_info(_player):
	ui.player_max_health = _player.max_health
	ui.player_current_health = _player.current_health
	ui.player_material_equipped = _player.material_equipped
	ui.player_current_materials = _player.material_equipped_amount
	
	ui.update()

func pass_player_position():
	enemies.pass_player_position(player.position)

func change_room(from_id, to_id):
	$"..".change_room(from_id, to_id)

func put_player_at_door(id):
	for door in doors.get_children():
		if door.to_id == id:
			player.position = door.position
	player.velocity = Vector2.ZERO

func save(save_area, save_id):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	#heal player and refill materials
	player.current_health = player.max_health
	
	if player.fire_material.unlocked:
		player.fire_material.current = player.fire_material.max
	if player.lightning_material.unlocked:
		player.lightning_material.current = player.lightning_material.max
	if player.water_material.unlocked:
		player.water_material.current = player.water_material.max
		
		#save room id
	area = save_area
	id = save_id
	
	file.store_var(area)
	file.store_var(id)
	
	#save player info
	max_health = player.max_health
	fire_unlocked = player.fire_material.unlocked
	fire_max = player.fire_material.max
	lightning_unlocked = player.lightning_material.unlocked
	lightning_max = player.lightning_material.max
	water_unlocked = player.water_material.unlocked
	water_max = player.water_material.max
	
	file.store_var(max_health)
	file.store_var(fire_unlocked)
	file.store_var(fire_max)
	file.store_var(lightning_unlocked)
	file.store_var(lightning_max)
	file.store_var(water_unlocked)
	file.store_var(water_max)
	file = FileAccess.open(save_path, FileAccess.READ)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		
		area = file.get_var()
		id = file.get_var()
		
		player.max_health = file.get_var()
		player.fire_material.unlocked = file.get_var()
		player.fire_material.max = file.get_var()
		player.lightning_material.unlocked = file.get_var()
		player.lightning_material.max = file.get_var()
		player.water_material.unlocked = file.get_var()
		player.water_material.max = file.get_var()
		
	#put player in room according to id
	for i in save_points.get_child_count():
		var save_point = save_points.get_child(i)
		
		if save_point.area == area and save_point.id == id:
			player.position = save_point.position
	pass_player_info($Player)

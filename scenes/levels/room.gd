extends Node2D
class_name Room

@export var player: Player
@export var enemies: LevelEnemies
@export var save_points: LevelSavePoints
@export var doors: LevelDoors
@export var ui: CanvasLayer
@export var camera: Camera2D

var save_path = "user://wizard-save-file.save"

var zooming_out := false

func _ready() -> void:
	pass_player_info(player)
	set_camera_limits()

@export var camera_limiter_bl: Node2D
@export var camera_limiter_tr: Node2D

func set_camera_limits():
	camera.limit_left = int(camera_limiter_bl.position.x)
	camera.limit_bottom = int(camera_limiter_bl.position.y)
	camera.limit_right = int(camera_limiter_tr.position.x)
	camera.limit_top = int(camera_limiter_tr.position.y)

func _process(_delta: float) -> void:
	if is_instance_valid(player):
		pass_player_position()
	
	if zooming_out:
		camera.zoom -= Vector2(0.01, 0.01)
		if camera.zoom.x <= 1:
			zooming_out = false

func pass_player_info(_player):
	ui.player_max_health = _player.max_health
	ui.player_current_health = _player.current_health
	ui.player_material_equipped = _player.equipped_material.material
	ui.player_current_materials = _player.equipped_material.current
	
	ui.update()

func pass_player_position():
	if player:
		enemies.pass_player_position(player.position)

func change_room(from_id, to_id):
	$"..".change_room(from_id, to_id)

func put_player_at_door(room_id):
	for child in doors.get_children(): #getting all doors
		if child is RoomDoor:
			var door = child
			if door.to_id == room_id: #checking if id from door player went through matches
				player.position = door.position #putting player at door
				if door.upwards:
					player.velocity.y = 200 #making player fall if coming through upwards door
				if door.downwards:
					player.velocity.y = -200 #making player rise if coming through downwards door
				return
	print("ERROR: No door with matching id")

@onready var level_gates = $LevelGates

func open_gates():
	level_gates.open_gates()

func close_doors():
	level_gates.close_gates()

var area
var id

var max_health
var fire_unlocked
var fire_max
var lightning_unlocked
var lightning_max
var water_unlocked
var water_max

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

func player_dead():
	$"..".player_dead()

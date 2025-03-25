extends Node2D

var current_scene: Node

var max_health: int
var current_health: int
var equipped_material: String
var fire_unlocked: bool
var fire_max: int
var fire_current: int
var lightning_unlocked: bool
var lightning_max: int
var lightning_current: int
var water_unlocked: bool
var water_max: int
var water_current: int

func _ready() -> void:
	current_scene = self.get_child(0)

func start_game():
	#remove starting screen as child
	remove_child(current_scene)
	#add first room as child
	change_room(112, 0)
	pass

func change_room(from_id, to_id):
	var new_room
	current_scene = self.get_child(0)
	#adding correct room scene as child of main
	match to_id:
		0:
			new_room = preload("res://scenes/levels/room.tscn")
		1:
			new_room = preload("res://scenes/rooms/room_1.tscn")
		2:
			new_room = preload("res://scenes/rooms/room_2.tscn")
		3:
			new_room = preload("res://scenes/rooms/room_3.tscn")
		4:
			new_room = preload("res://scenes/rooms/room_4.tscn")
		5:
			new_room = preload("res://scenes/rooms/room_5.tscn")
		6:
			new_room = preload("res://scenes/rooms/room_6.tscn")
		7:
			new_room = preload("res://scenes/rooms/room_7.tscn")
		8:
			new_room = preload("res://scenes/rooms/room_8.tscn")
		9:
			new_room = preload("res://scenes/rooms/room_9.tscn")
		10:
			new_room = preload("res://scenes/rooms/room_10.tscn")
		11:
			new_room = preload("res://scenes/rooms/room_11.tscn")
		12:
			new_room = preload("res://scenes/rooms/room_12.tscn")
		13:
			new_room = preload("res://scenes/rooms/room_13.tscn")
		14:
			new_room = preload("res://scenes/rooms/room_14.tscn")
		15:
			new_room = preload("res://scenes/rooms/room_15.tscn")
		16:
			new_room = preload("res://scenes/rooms/room_16.tscn")
		17:
			new_room = preload("res://scenes/rooms/room_17.tscn")
		18:
			new_room = preload("res://scenes/rooms/room_18.tscn")
		19:
			new_room = preload("res://scenes/rooms/room_19.tscn")
		20:
			new_room = preload("res://scenes/rooms/room_20.tscn")
		21:
			new_room = preload("res://scenes/rooms/room_21.tscn")
		22:
			new_room = preload("res://scenes/rooms/room_22.tscn")
		23:
			new_room = preload("res://scenes/rooms/room_23.tscn")
		24:
			new_room = preload("res://scenes/rooms/room_24.tscn")
		25:
			new_room = preload("res://scenes/rooms/room_25.tscn")
		26:
			new_room = preload("res://scenes/rooms/room_26.tscn")
		27:
			new_room = preload("res://scenes/rooms/room_27.tscn")
		28:
			new_room = preload("res://scenes/rooms/room_28.tscn")
		29:
			new_room = preload("res://scenes/rooms/room_29.tscn")
		30:
			new_room = preload("res://scenes/rooms/room_30.tscn")
		31:
			new_room = preload("res://scenes/rooms/room_31.tscn")
		32:
			new_room = preload("res://scenes/rooms/room_32.tscn")
		113:
			new_room = preload("res://scenes/screens/win_screen.tscn")
		_:
			print("no level found with matching id")
	
	#storing player info and removing current room
	if from_id != 112:
		store_player_info()
	else:
		set_beginning_player_info()
	call_deferred("remove_child", current_scene)
	
	#ading new room and returning player info
	new_room = new_room.instantiate()
	self.call_deferred("add_child", new_room)
	return_player_info(new_room)
	
	#putting player at correct door
	if from_id != 112 and to_id != 113:
		new_room.put_player_at_door(from_id)
	current_scene = new_room

func set_beginning_player_info() -> void:
	max_health = 100
	current_health = 100
	equipped_material = "fire"
	
	fire_unlocked = true
	fire_max = 50
	fire_current = 50
	
	lightning_unlocked = false
	lightning_max = 0
	lightning_current = 0
	
	water_unlocked = false
	water_max = 0
	water_current = 0
func store_player_info() -> void:
	for child in current_scene.get_children():
		if child.name == "Player":
			var player = child
			
			max_health = player.max_health
			current_health = player.current_health
			equipped_material = player.equipped_material.material
			
			fire_unlocked = player.fire_material.unlocked
			fire_max = player.fire_material.max
			fire_current = player.fire_material.current
			
			lightning_unlocked = player.lightning_material.unlocked
			lightning_max = player.lightning_material.max
			lightning_current = player.lightning_material.current
			
			water_unlocked = player.water_material.unlocked
			water_max = player.water_material.max
			water_current = player.water_material.current
			return
	print("no player found")

func return_player_info(_new_room) -> void:
	for child in _new_room.get_children():
		if child.name == "Player":
			var player = child
			
			player.max_health = max_health
			player.current_health = current_health
			
			player.fire_material.unlocked = fire_unlocked
			player.fire_material.max = fire_max
			player.fire_material.current = fire_current
			
			player.lightning_material.unlocked = lightning_unlocked
			player.lightning_material.max = lightning_max
			player.lightning_material.current = lightning_current
			
			player.water_material.unlocked = water_unlocked
			player.water_material.max = water_max
			player.water_material.current = water_current
			
			player.switch_material(equipped_material)
			return
	print("no player found")

func player_dead():
	var death_screen_path = preload("res://scenes/screens/death_screen.tscn")
	var death_screen = death_screen_path.instantiate()
	print(current_scene)
	remove_child(current_scene)
	add_child(death_screen)

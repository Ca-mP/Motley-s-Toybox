extends Node2D

var current_room: Node

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
	current_room = self.get_child(0)

func change_room(from_id, to_id):
	var new_room
	current_room = self.get_child(0)
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
		_:
			print("no level found with matching id")
			return
	
	#storing player info and removing current room
	store_player_info()
	call_deferred("remove_child", current_room)
	
	#ading new room and returning player info
	new_room = new_room.instantiate()
	self.call_deferred("add_child", new_room)
	return_player_info(new_room)
	
	#putting player at correct door
	new_room.put_player_at_door(from_id)
	current_room = self.get_child(0)

func store_player_info() -> void:
	for child in current_room.get_children():
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

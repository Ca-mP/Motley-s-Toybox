extends Node2D

var room0 = "res://scenes/levels/level.tscn"
var room1 = "res://scenes/rooms/room_1.tscn"

var room_ids = [
	[0, room0],
	[1, room1]
]

func change_room(from_id, to_id):
	var current_room = self.get_child(0)
	var new_room
	#adding correct room scene as child of main
	match to_id:
		0:
			new_room = preload("res://scenes/levels/room.tscn")
		1:
			new_room = preload("res://scenes/rooms/room_1.tscn")
		_:
			print("no level found with matching id")
			return
	self.call_deferred("remove_child", current_room)
	new_room = new_room.instantiate()
	self.call_deferred("add_child", new_room)
	
	#putting player at correct door
	new_room.put_player_at_door(from_id)

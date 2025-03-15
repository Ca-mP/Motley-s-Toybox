extends Area2D
class_name RoomDoor

@export var from_id: int
@export var to_id: int
@export var downwards: bool
@export var upwards: bool

var can_leave := false
var can_can_leave := false
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	can_leave = false
	
	#adding and starting stupid timer
	var stupid_timer = Timer.new()
	stupid_timer.wait_time = 0.1
	self.add_child(stupid_timer)
	stupid_timer.timeout.connect(on_timeout)
	stupid_timer.start()

func _process(_delta: float) -> void:
	#making it detect player only after player leaves or is not in area
	if not has_overlapping_areas() and can_can_leave:
		can_leave = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and can_leave:
		$"..".change_room(from_id, to_id)

func on_timeout():
	can_can_leave = true

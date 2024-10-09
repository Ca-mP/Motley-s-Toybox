extends Area2D
class_name RoomDoor

@export var from_id: int
@export var to_id: int
@export var stupid_timer: Timer

var can_leave := false
var can_can_leave := false
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	can_leave = false
	stupid_timer.timeout.connect(on_timeout)
	stupid_timer.start()

func _process(delta: float) -> void:
	#making it detect player only after player leaves or is not in area
	if not has_overlapping_areas() and can_can_leave:
		can_leave = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and can_leave:
		$"..".change_room(from_id, to_id)

func on_timeout():
	can_can_leave = true

extends Room

func _ready() -> void:
	pass_player_info_test()
	set_camera_limits()

func pass_player_info_test():
	pass_player_info(player)

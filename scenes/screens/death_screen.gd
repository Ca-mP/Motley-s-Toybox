extends Node2D

func _on_button_pressed() -> void:
	$"..".start_game()

func _process(delta: float) -> void:
	if Input.is_action_just_released("select") or Input.is_action_just_pressed("start"):
		BgMusic.play()
		$"..".start_game()

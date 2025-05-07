extends Node2D

const TARGET_POS = 50
var speed = 4

func _process(_delta: float) -> void:
	var pos = $"ColorRect/VBoxContainer".position.y
	if pos > TARGET_POS - 3 and pos < TARGET_POS + 3:
		pass
	else:
		$"ColorRect/VBoxContainer".position.y -= speed
		if speed > 0.2:
			speed -= 0.01
	
	if Input.is_action_just_pressed("select") or Input.is_action_just_pressed("start"):
		$"..".start_game()

func _on_texture_button_pressed() -> void:
	GameState.brute_boss_beaten = false
	$"..".start_game()

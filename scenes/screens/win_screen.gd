extends Node2D

const TARGET_POS = 87

func _process(delta: float) -> void:
	var pos = $"ColorRect/VBoxContainer".position.y
	if pos > TARGET_POS - 3 and pos < TARGET_POS + 3:
		pass
	else:
		$"ColorRect/VBoxContainer".position.y -= 5

func _on_button_pressed() -> void:
	GameState.brute_boss_beaten = false
	$"..".start_game()

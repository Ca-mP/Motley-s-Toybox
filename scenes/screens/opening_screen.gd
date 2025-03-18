extends Node2D



func _on_button_pressed():
	BgMusic.play()
	$"..".start_game()

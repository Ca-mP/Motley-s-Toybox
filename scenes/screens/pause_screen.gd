extends Control

func _on_quit_button_pressed() -> void:
	print("quit")
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	print("continue")


func _on_continue_button_button_down() -> void:
	print("pressed down")

extends Control

@onready var continue_button = $ColorRect/VBoxContainer/ContinueButton

func _ready() -> void:
	continue_button.pressed.connect(b)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	print("continue")

func b():
	print("continue")

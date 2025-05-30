extends Control

@onready var start_button = $ColorRect/VBoxContainer/StartButton
@onready var exit_button = $ColorRect/VBoxContainer/ExitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(continue_game)
	exit_button.pressed.connect(exit_game)

func continue_game():
	get_tree().paused = false
	queue_free()

func exit_game():
	get_tree().quit()

extends Control

@onready var start_button = $ColorRect/VBoxContainer/StartButton
@onready var exit_button = $ColorRect/VBoxContainer/ExitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(continue_game)
	exit_button.pressed.connect(exit_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func continue_game():
	print("start")

func exit_game():
	print("exit")

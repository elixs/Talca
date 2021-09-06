extends CanvasLayer


onready var start_button = $Panel/VBoxContainer/Start
onready var quit_button = $Panel/VBoxContainer/Quit

func _ready() -> void:
	start_button.connect("pressed", self,  "on_start_pressed")
	quit_button.connect("pressed", self,  "on_quit_pressed")

func on_start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func on_quit_pressed():
	get_tree().quit()

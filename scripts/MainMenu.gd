extends CanvasLayer


onready var start_button = $Panel/VBoxContainer/Start
onready var quit_button = $Panel/VBoxContainer/Quit


func _ready() -> void:
	start_button.connect("pressed", self,  "_on_start_pressed")
	quit_button.connect("pressed", self,  "_on_quit_pressed")


func _on_start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_quit_pressed():
	get_tree().quit()

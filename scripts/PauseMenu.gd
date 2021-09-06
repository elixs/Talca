tool
extends CanvasLayer

onready var pause_menu = $Panel
onready var continue_btn = $Panel/VBoxContainer/Continue
onready var main_menu_btn = $Panel/VBoxContainer/MainMenu
onready var quit_btn = $Panel/VBoxContainer/Quit

export(bool) var visible = true setget set_visible
func set_visible(value):
	visible = value
	$Panel.visible = visible 



func _ready() -> void:
	continue_btn.connect("pressed", self, "on_continue_pressed")
	main_menu_btn.connect("pressed", self, "on_main_menu_pressed")
	quit_btn.connect("pressed", self, "on_quit_pressed")
	
	pause_menu.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not event.is_echo():
		pause_menu.show()
		get_tree().paused = true

func on_continue_pressed():
		pause_menu.hide()
		get_tree().paused = false
		
func on_main_menu_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	get_tree().paused = false
	
func on_quit_pressed():
	get_tree().quit()

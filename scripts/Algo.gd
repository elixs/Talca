extends KinematicBody2D


onready var label = $Label
onready var timer = $Timer

func _ready() -> void:
	label.hide()
	timer.connect("timeout", self, "on_timeout")
#	if Manager.player:
#		Manager.player.connect("jumped", self, "on_jumped")

func on_jumped(meh, owo):
	label.show()
	timer.start()
		

func on_timeout():
	label.hide()

func take_damage(damage):
	label.show()
	timer.start()

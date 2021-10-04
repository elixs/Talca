extends KinematicBody2D


onready var label = $Label
onready var timer = $Timer


func _ready() -> void:
	label.hide()
	timer.connect("timeout", self, "_on_timeout")


func take_damage(_damage):
	label.show()
	timer.start()


func _on_timeout():
	label.hide()



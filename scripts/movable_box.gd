extends KinematicBody2D


onready var area = $Area2D
onready var prompt = $Prompt


func _ready() -> void:
	prompt.hide()
	
	area.connect("body_entered", self, "_on_body_entered")
	area.connect("body_exited", self, "_on_body_exited")


func interact(player: Player):
	player.start_pushing()
	

func _on_body_entered(player: Player):
	player.interactables.append(self)
	prompt.show()


func _on_body_exited(player: Player):
	player.interactables.erase(self)
	prompt.hide()

extends Area2D


onready var respawn = $Respawn

func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node):
	Manager.respawn = respawn.global_position

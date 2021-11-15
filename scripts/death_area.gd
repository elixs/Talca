extends Area2D


func _ready():
	connect("body_entered", self, "_on_player_entered")


func _on_player_entered(player: Player):
	player.health = 0

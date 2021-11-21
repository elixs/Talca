extends StaticBody2D


var offset = 66

onready var area = $Area2D
onready var prompt = $Prompt
onready var raycast_right = $RayCast2D
onready var raycast_left = $RayCast2D2


func _ready() -> void:
	prompt.hide()
	
	area.connect("body_entered", self, "_on_body_entered")
	area.connect("body_exited", self, "_on_body_exited")


func interact(player: Player):
	player.start_pushing()
	prompt.hide()


func _on_body_entered(player: Player):
	if player.movable_box == self:
		return
	
	if player.global_position.x < global_position.x and not raycast_left.is_colliding():
		return
	
	if player.global_position.x > global_position.x and not raycast_right.is_colliding():
		return
	
	player.interactables.append(self)
	prompt.show()


func _on_body_exited(player: Player):
	player.interactables.erase(self)
	prompt.hide()

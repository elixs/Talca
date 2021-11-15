extends Node2D


onready var clouds = $Clouds
onready var player = $Completinna
onready var evil_honguito = $EvilHonguito

func _ready():
	player.connect("jumped", evil_honguito, "on_player_jumped")
	

func _process(delta):
	clouds.scroll_base_offset.x += delta * 20

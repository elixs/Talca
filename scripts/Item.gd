extends Node2D

var potion = Rect2(16,0, 16, 16)
var fish = Rect2(144, 48, 16, 16)
var default = Rect2(16, 32, 16, 16)

onready var sprite = $Sprite
onready var quantity = $Quantity

var data: Dictionary = {}

func _ready() -> void:
	if not data.empty():
		sprite.texture.region = get_region_from_id(data["id"])
		var item_quantity = get_quantity()
		if item_quantity > 1:
			quantity.text = str(item_quantity)
			quantity.show()
		else:
			quantity.hide()

func get_region_from_id(id: String):
	var region = default
	match id:
		"potion":
			region = potion
		"fish":
			region = fish
	return region

func get_quantity():
	if data.empty():
		return 0
	else:
		return int(data["quantity"])

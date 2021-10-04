extends Node2D

const POTION = Rect2(16,0, 16, 16)
const FISH = Rect2(144, 48, 16, 16)
const DEFAULT = Rect2(16, 32, 16, 16)

var id: String
var quantity: int = 0 setget set_quantiy

onready var sprite = $Sprite
onready var quantity_label = $Quantity


func _ready() -> void:
	if id:
		sprite.texture.region = _get_region_from_id(id)
		var item_quantity_label = quantity
		if item_quantity_label > 1:
			quantity_label.text = str(item_quantity_label)
			quantity_label.show()
		else:
			quantity_label.hide()


func set_quantiy(value):
	quantity = value
	if not quantity_label:
		return
	quantity_label.text = str(quantity)


func _get_region_from_id(id: String):
	var region = DEFAULT
	match id:
		"potion":
			region = POTION
		"fish":
			region = FISH
	return region

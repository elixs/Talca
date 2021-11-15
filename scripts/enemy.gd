class_name Enemy

extends KinematicBody2D

export var SPEED = 200

const ACCELERATION = 1000
const GRAVITY = 2000

var velocity = Vector2.ZERO

var health = 100 setget _set_health
var max_health = 100


onready var health_bar = $HealthBar

func _ready():
	self.health = health


func _set_health(value):
	health = clamp(value, 0, max_health)
	health_bar.value = health
	
	if health == 0:
		queue_free()

func take_damage(value):
	print("Auch! %d" % [value])
	self.health -= value

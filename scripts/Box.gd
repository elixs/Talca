class_name Box

extends RigidBody2D

export var SPEED = 500
export var ACCELERATION = 250

var target: Node2D

func grab():
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)

func launch(direction: Vector2):
	call_deferred("_launch", direction)
	
func _launch(direction: Vector2):
	mode = RigidBody2D.MODE_RIGID
	apply_central_impulse(direction * SPEED)
	target = null

func _physics_process(delta: float) -> void:
	if target:
		global_position = lerp(global_position, target.global_position, 0.1)

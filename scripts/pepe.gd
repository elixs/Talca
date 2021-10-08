extends KinematicBody2D


const ACCELERATION = 1500
const SPEED = 200

var velocity = Vector2.ZERO
var last_direction = Vector2.UP


onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")


func _ready() -> void:
	anim_tree.active = true


func _physics_process(delta: float) -> void:
	velocity = move_and_slide(velocity)
	
	var move_input: Vector2 = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	move_input = move_input.normalized()
	
	# Isometric movement
#	move_input = move_input.rotated(PI/4)
	
	velocity = velocity.move_toward(move_input * SPEED, ACCELERATION * delta)
	
	_handle_animation()
	_handle_direction(move_input)


func _handle_animation():
	if velocity.length() < 10:
		playback.travel("idle")
	else:
		playback.travel("move")


func _handle_direction(move_input: Vector2):
	var direction = move_input
	direction.x = sign(direction.x)
	direction.y = sign(direction.y)
	
	if direction.x != 0 or direction.y != 0:
		last_direction = direction
	
	anim_tree.set("parameters/idle/blend_position", last_direction)
	anim_tree.set("parameters/move/blend_position", last_direction)
	
	
	

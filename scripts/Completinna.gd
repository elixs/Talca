extends KinematicBody2D

var lineal_vel = Vector2.ZERO
var SPEED = 300
var ACCELERATION = 100
var GRAVITY = 400

var _facing_right = true

signal jumped(meh, owo)

onready var playback = $AnimationTree.get("parameters/playback")

onready var jump_sound = $JumpSound

var Bullet = preload("res://scenes/Bullet.tscn")

func _ready() -> void:
	Manager.player = self
	$AnimationTree.active = true
	get_node("AnimationPlayer")
	
	connect("mouse_entered", self, "_on_mouse_entered")

	
func _on_mouse_entered():
	print("owo")

func _physics_process(delta: float) -> void:
	lineal_vel = move_and_slide(lineal_vel, Vector2.UP)
	lineal_vel.y += GRAVITY * delta
	
	var on_floor = is_on_floor()
	
	var target_vel = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	lineal_vel.x = move_toward(lineal_vel.x, target_vel * SPEED, ACCELERATION)
	
	if on_floor and Input.is_action_just_pressed("jump"):
		lineal_vel.y = -SPEED
		jump_sound.play()
		emit_signal("jumped", "asdf", 123)
	
	if Input.is_action_just_pressed("fire"):
		_fire()
	
	# angle between head and floor normal
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		print((-transform.y).angle_to(collision.normal))
	
	
	# Animations
	if on_floor:
		if abs(lineal_vel.x) > 10:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if lineal_vel.y <= 0:
			playback.travel("jump")
		else:
			playback.travel("fall")
	

	if Input.is_action_pressed("left") and not Input.is_action_pressed("right") and _facing_right:
		_facing_right = false
		scale.x = -1
	if Input.is_action_pressed("right") and not Input.is_action_pressed("left") and not _facing_right:
		_facing_right = true
		scale.x = -1

func _fire():
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	bullet.global_position = $BulletSpawn.global_position
	if not _facing_right:
		bullet.rotation = PI


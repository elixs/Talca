extends KinematicBody2D

var lineal_vel = Vector2.ZERO
var SPEED = 300
var ACCELERATION = 100
var GRAVITY = 400

var _facing_right = true
export(bool) var can_move = true

signal jumped(meh, owo)

onready var playback = $AnimationTree.get("parameters/playback")

onready var jump_sound = $JumpSound

onready var animation_tree = $AnimationTree
onready var attack = $AttackPosition/Attack
onready var attack_position = $AttackPosition
onready var grab_area = $GrabArea
onready var grab_position = $GrabPosition
onready var grab_area_collision = $GrabArea/CollisionShape2D
onready var attack_area = $AttackArea


var _box : Box = null

var Bullet = preload("res://scenes/Bullet.tscn")

func _ready() -> void:
	Manager.player = self

	
	connect("mouse_entered", self, "_on_mouse_entered")
	
	grab_area.connect("body_entered", self, "on_box_entered")
	attack_area.connect("body_entered", self, "on_attack_body_entered")
	
	_start_player()

func _start_player():
	animation_tree.active = true
	attack.hide()
	can_move = true
	grab_area_collision.disabled = true

	
func _on_mouse_entered():
	print("owo")

func _physics_process(delta: float) -> void:
	lineal_vel = move_and_slide(lineal_vel, Vector2.UP)
	lineal_vel.y += GRAVITY * delta
	
	var on_floor = is_on_floor()
	
	var target_vel = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if not can_move:
		target_vel = 0
	
	lineal_vel.x = move_toward(lineal_vel.x, target_vel * SPEED, ACCELERATION)
	
	if on_floor and Input.is_action_just_pressed("jump"):
		lineal_vel.y = -SPEED
		jump_sound.play()
		emit_signal("jumped", "asdf", 123)
	
	if Input.is_action_just_pressed("fire"):
		_fire()
		
	if Input.is_action_just_pressed("attack"):
		playback.travel("attack")
		return
	
	if on_floor and not _box and Input.is_action_just_released("grab"):
		_grab()
		return
	
	if can_move and _box and Input.is_action_just_released("grab"):
		_drop()
		
	
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
	
	
	if playback.get_current_node() == "grab":
		return

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

func _grab():
	playback.travel("grab")

func _drop():
	if abs(lineal_vel.x) > 10:
		_box.launch(Vector2((1 if _facing_right else -1) * 30, -5))
	else:
		_box.launch(Vector2.ZERO)
	_box.remove_child(attack)
	attack_position.add_child(attack)
	_box = null
	

func on_box_entered(box: Box):
	if box:
		_box = box
		attack.get_parent().remove_child(attack)
		_box.add_child(attack)
		_box.grab()
		_box.target = grab_position
		attack.show()

func on_attack_body_entered(body: Node):
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(10)

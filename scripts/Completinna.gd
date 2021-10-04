extends KinematicBody2D


signal jumped(meh, owo)

const SPEED = 300
const JUMP_SPEED = 750
const ACCELERATION = 3000
const GRAVITY = 2000
const Bullet = preload("res://scenes/bullet.tscn")

var linear_vel = Vector2.ZERO

var _facing_right = true
var _box : Box = null

onready var animation_tree = $AnimationTree
onready var playback = animation_tree.get("parameters/StateMachine/playback") # A blend tree was added as root in order to apply a x1.25 speed to all animations
onready var jump_sound = $JumpSound
onready var attack = $AttackPosition/Attack
onready var attack_position = $AttackPosition
onready var grab_area = $GrabArea
onready var grab_position = $GrabPosition
onready var grab_area_collision = $GrabArea/CollisionShape2D
onready var attack_area = $AttackArea


func _ready() -> void:
	Manager.player = self
	
	connect("mouse_entered", self, "_on_mouse_entered")
	
	grab_area.connect("body_entered", self, "_on_box_entered")
	attack_area.connect("body_entered", self, "_on_attack_body_entered")
	
	_start_player()


func _physics_process(delta: float) -> void:
	var can_move = not (playback.get_current_node() == "grab" or playback.get_current_node() == "attack")
	
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	linear_vel.y += GRAVITY * delta
	
	var on_floor = is_on_floor()
	
	var target_vel = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if not can_move:
		target_vel = 0
	
	linear_vel.x = move_toward(linear_vel.x, target_vel * SPEED, ACCELERATION * delta)
	
	if on_floor and Input.is_action_just_pressed("jump"):
		linear_vel.y = -JUMP_SPEED
		jump_sound.play()
		emit_signal("jumped", "asdf", 123)
	
	if Input.is_action_just_pressed("fire"):
		_fire()
		
	if on_floor and Input.is_action_just_pressed("attack"):
		_attack()
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
	
	_update_animation(on_floor)
	
	if not can_move:
		return

	if Input.is_action_pressed("left") and not Input.is_action_pressed("right") and _facing_right:
		_facing_right = false
		scale.x = -1
	if Input.is_action_pressed("right") and not Input.is_action_pressed("left") and not _facing_right:
		_facing_right = true
		scale.x = -1


func _update_animation(on_floor):
	if on_floor:
		if abs(linear_vel.x) > 10:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if linear_vel.y <= 0:
			playback.travel("jump")
		else:
			playback.travel("fall")


func _start_player():
	animation_tree.active = true
	attack.hide()
	grab_area_collision.disabled = true


func _on_mouse_entered():
	print("owo")


func _fire():
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	bullet.global_position = $BulletSpawn.global_position
	if not _facing_right:
		bullet.rotation = PI


func _attack():
	playback.travel("attack")


func _grab():
	playback.travel("grab")


func _drop():
	if abs(linear_vel.x) > 10:
		_box.launch(Vector2((1 if _facing_right else -1) * 30, -5))
	else:
		_box.launch(Vector2.ZERO)
	_box.remove_child(attack)
	attack_position.add_child(attack)
	_box = null


func _on_box_entered(box: Box):
	if box:
		_box = box
		attack.get_parent().remove_child(attack)
		_box.add_child(attack)
		_box.grab()
		_box.target = grab_position
		attack.show()


func _on_attack_body_entered(body: Node):
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(10)

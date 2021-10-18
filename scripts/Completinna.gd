class_name Player
extends KinematicBody2D

enum State {
	MOVING,
	PUSHING
}

signal jumped(meh, owo)

const SPEED = 300
const JUMP_SPEED = 750
const ACCELERATION = 3000
const GRAVITY = 2000
const Bullet = preload("res://scenes/bullet.tscn")
const ParabolicBullet = preload("res://scenes/parabolic_bullet.tscn")

var linear_vel = Vector2.ZERO
var health = 100 setget _set_health
var max_health = 100

var current_state = State.MOVING
var interactables: Array = []

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
onready var progress_bar = $CanvasLayer/MarginContainer3/ProgressBar

func _ready() -> void:
	Manager.player = self
	
	connect("mouse_entered", self, "_on_mouse_entered")
	
	grab_area.connect("body_entered", self, "_on_box_entered")
	attack_area.connect("body_entered", self, "_on_attack_body_entered")
	
	_start_player()


func _physics_process(delta: float) -> void:
	match current_state:
		State.MOVING:
			_moving(delta)
		State.PUSHING:
			_pushing(delta)


func _moving(delta: float) -> void:
	
	var can_move = not (playback.get_current_node() == "grab" or playback.get_current_node() == "attack")
	
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	linear_vel.y += GRAVITY * delta
	
	var on_floor = is_on_floor()
	
	var target_vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if not can_move:
		target_vel = 0
	
	linear_vel.x = move_toward(linear_vel.x, target_vel * SPEED, ACCELERATION * delta)
	
	if on_floor and Input.is_action_just_pressed("jump"):
		linear_vel.y = -JUMP_SPEED
		jump_sound.play()
		emit_signal("jumped", "asdf", 123)
	
	if Input.is_action_just_pressed("fire"):
		if interactables.size() > 0:
			var interactable = interactables.back()
			if interactable.has_method("interact"):
				interactable.interact(self)
		else:
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

	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right") and _facing_right:
		_facing_right = false
		scale.x = -1
	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left") and not _facing_right:
		_facing_right = true
		scale.x = -1


func _pushing(delta: float) -> void:
	pass
	# if you start falling, go to moving
	# if you collide with an obstacle, the animation don't stop

func start_pushing():
	call_deferred("set_state", State.PUSHING)

func set_state(new_state):
#	match current_state:
	
#	match new_state:

	current_state = new_state


func take_damage(value):
	print("Auch! %d" % [value])
	self.health -= value


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


#func _fire():
#	var bullet = Bullet.instance()
#	get_parent().add_child(bullet)
#	bullet.global_position = $BulletSpawn.global_position
#	if not _facing_right:
#		bullet.rotation = PI


func _fire():
	var bullet = ParabolicBullet.instance()
	get_parent().add_child(bullet)
	bullet.global_position = $BulletSpawn.global_position
	var direction = Vector2(1, -1)
	if not _facing_right:
		direction.x *= -1
	bullet.launch(direction)


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


func _set_health(value):
	health = clamp(value, 0, max_health)
	progress_bar.value = health

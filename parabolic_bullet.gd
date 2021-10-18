extends Area2D


export var SPEED = 300

const GRAVITY = 400

var velocity = Vector2.ZERO


func _ready() -> void:
	var _error = connect("body_entered", self, "_on_body_entered")
	set_physics_process(false)


func launch(direction):
	velocity = direction.normalized() * SPEED
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity.y += GRAVITY * delta


func _on_body_entered(body: Node):
	if not body.is_in_group("player"):
		queue_free()

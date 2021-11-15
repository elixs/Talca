extends Enemy


var direction = Vector2.RIGHT

onready var pivot = $Pivot
onready var wall_ray_cast = $Pivot/WallRayCast
onready var floor_ray_cast = $Pivot/FloorRayCast


func _physics_process(delta: float) -> void:
	velocity = move_and_slide(velocity, Vector2.UP)
	var on_floor = is_on_floor()
	velocity.y += GRAVITY * delta
	
	
	velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	
	# Raycasts
	if on_floor and (wall_ray_cast.is_colliding() or not floor_ray_cast.is_colliding()):
		pivot.scale.x *= -1
		direction.x *= -1

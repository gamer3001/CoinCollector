extends CharacterBody2D

const SPEED = 400.0

func _physics_process(delta):
	# Get input direction
	var direction = Input.get_axis("move_left", "move_right")
	var vertical = Input.get_axis("move_up", "move_down")
	
	# Apply movement
	velocity = Vector2(direction, vertical).normalized() * SPEED
	
	move_and_slide()
	
	# Keep player in screen bounds
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
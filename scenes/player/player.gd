extends CharacterBody2D

signal died

enum State { IDLE, WALKING, JUMPING }

var gravity: float = 1000
var horizontal_acceleration: float = 2000
var jump_horizontal_acceleration: float = 1000
var max_horizontal_speed: float = 140
var jump_speed: float = -200
var jump_termination_multiplier: float = 1.5
var current_state: State = State.IDLE
var has_double_jump: bool = true
var has_triple_jump: bool = true

func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			process_idle(delta)
		State.JUMPING:
			process_jumping(delta)
		State.WALKING:
			process_walking(delta)

func change_state(new_state: State) -> void:
	current_state = new_state

# The idle state is when the character is standing around and not moving.
# In that case, we want to just do nothing until the player acts
func process_idle(delta: float) -> void:
	# Get the movement direction (if one is applied)
	var direction := Input.get_axis("move_left", "move_right")
	
	# If the user just jumped, apply the jump speed. Otherwise, if they're not
	# on the ground, also change to jumping but without applying extra movement.
	# Finally, if the direction is not zero, then switch to walking.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		change_state(State.JUMPING)
	elif not is_on_floor():
		change_state(State.JUMPING)
	elif direction != 0:
		change_state(State.WALKING)
	
	# In any case, if the movement is not zero, gradually move to zero
	velocity.x = lerpf(0, velocity.x, pow(2, -40 * delta))
	
	# Apply physics and update animation details
	move_and_slide()
	update_animation()
	
	# After physics is applied, if we're on the ground, reset the double and
	# triple jumps.
	if is_on_floor():
		has_double_jump = true
		has_triple_jump = true

# The jumping state is anytime we're not on the ground
func process_jumping(delta: float) -> void:
	# Obtain the movement direction
	var direction := Input.get_axis("move_left", "move_right")
	
	# If we're on the ground, switch states to the walking/idle state.
	if is_on_floor():
		if direction:
			change_state(State.WALKING)
		else:
			change_state(State.IDLE)
	
	# If the user just hit jump, while we're already in a jump, use the double
	# or triple jump.
	if Input.is_action_just_pressed("jump"):
		if has_double_jump:
			velocity.y = jump_speed
			has_double_jump = false
		elif has_triple_jump:
			velocity.y = jump_speed
			has_triple_jump = false
	
	# If there is a direction, apply the movement speed to it. Otherwise gradually
	# move to zero
	if direction:
		velocity.x += direction * jump_horizontal_acceleration * delta
	else:
		velocity.x = lerpf(0, velocity.x, pow(2, -40 * delta))
	velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	
	# Because we're in the air, apply gravity to the character
	if not Input.is_action_pressed("jump"):
		velocity.y += (get_gravity() * jump_termination_multiplier * delta).y
	else:
		velocity += get_gravity() * delta
	
	# Update physics and animations
	move_and_slide()
	update_animation()

func process_walking(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	# If jump was pressed, switch to jumping. If there is no movement, switch
	# to idle.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		change_state(State.JUMPING)
	elif not is_on_floor():
		change_state(State.JUMPING)
	elif direction == 0:
		change_state(State.IDLE)
	
	# If there is a movement, apply the movement speed, or move to zero if no
	# movement direction
	if direction:
		velocity.x += direction * horizontal_acceleration * delta
	else:
		velocity.x = lerpf(0, velocity.x, pow(2, -40 * delta))
	velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	
	# Update physics and animation
	move_and_slide()
	update_animation()
	
	# If we're on the ground, reset the jumps
	if is_on_floor():
		has_double_jump = true
		has_triple_jump = true

func get_movement_vector() -> Vector2:
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	
	return move_vector

func update_animation() -> void:
	var move_vector = get_movement_vector()
	
	if is_on_floor():
		if move_vector.x == 0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
	
	if move_vector.x > 0:
		$AnimatedSprite2D.set_deferred("flip_h", true)
	elif move_vector.x < 0:
		$AnimatedSprite2D.set_deferred("flip_h", false)

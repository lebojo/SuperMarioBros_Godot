extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -1600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 5000
var acceleration = -SPEED
var jump_acceleration = 0.0

var old_dir = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_acceleration = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$anim.stop()
		$Sprite2D.frame = 5
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y = 0

	# Handle sprint.
	if Input.is_action_pressed("sprint"):
		acceleration += 10
		$anim.speed_scale = 2
	else:
		$anim.speed_scale = 1
		if acceleration > 0:
			acceleration -= 10

	acceleration = mini(acceleration, 300)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		if direction != old_dir:
			old_dir = direction
		if not is_on_floor():
			if acceleration > -SPEED:
				acceleration -= 5
		if acceleration < 0:
			acceleration += 20
		velocity.x = old_dir * (SPEED + acceleration)
		$Sprite2D.scale.x = direction
	else:
		if acceleration > -SPEED:
			acceleration -= 50
		if acceleration < -SPEED:
			acceleration = -SPEED
		velocity.x = old_dir * (SPEED + acceleration)

	move_and_slide()
	if velocity.x != 0 and is_on_floor():
		$anim.play("walk")
	else:
		if is_on_floor():
			$anim.stop()
			$Sprite2D.frame = 0
	var lst_clsn = get_last_slide_collision()
	if lst_clsn and lst_clsn.get_collider() is TileMap:
		var tm = lst_clsn.get_collider()
		var tm_pos = tm.local_to_map(lst_clsn.get_position())
		var cell = tm.get_cellv(tm_pos)
		if cell:
			cell.flip_h = true

extends Node2D

const GRAVITY = 1000;
const FALLING_MUTIPLIER = 1.25;
const FAST_FALL_MULTIPLIER = 2; # Not holding jump
const HYPER_FALL_MULTIPLIER = 1.25; # Holding down
const SHORT_HOP_MULTIPLIER = 0.7;
const MAX_FALL_SPEED = 1500.0;

const JUMP_HEIGHT = 200.0;
const JUMP_VELOCITY = -sqrt(2.0 * GRAVITY * JUMP_HEIGHT);
const RUN_ACCELERATION = 20000
const WALK_SPEED = 300.0;
const JUMP_BUFFER_DURATION = 0.1;
const COYOTE_BUFFER_DURATION = 0.05;

var velocity = Vector2.ZERO;

var jump_buffered = false;
var jump_buffered_timer = 0.0;
var coyote_timer = 0.0;

var tile_shape;
var collidable_container;

func _ready():
	collidable_container = get_parent().get_node("level2").get_node("collideableTiles");
	tile_shape = collidable_container.shape_owner_get_shape(0, 0);

func is_colliding_with_collidable():
	for tilemap in collidable_container.get_children():
		for tile_pos in tilemap.get_used_cells():
			if get_child(0).shape.collide(transform, tile_shape, Transform2D(0.0, tile_pos * tilemap.cell_size)):
				return true;

	return false;

func is_grounded():
	for tilemap in collidable_container.get_children():
		for tile_pos in tilemap.get_used_cells():
			if get_child(0).shape.collide_with_motion(transform, Vector2.DOWN, tile_shape, Transform2D(0.0, tile_pos * tilemap.cell_size), Vector2.ZERO):
				coyote_timer = COYOTE_BUFFER_DURATION;
				return true

	if coyote_timer > 0.0:
		return true;
	
	return false
		
func _process(delta):
	# Set velocity
	var direction = sign(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var jump_pressed = Input.is_action_just_pressed("jump")
	var jump_released = Input.is_action_just_released("jump")
	var grounded = is_grounded();

	coyote_timer = max(coyote_timer - delta, 0.0);
	jump_buffered_timer = max(jump_buffered_timer - delta, 0.0);
	if jump_pressed || jump_buffered:
		if grounded && (jump_pressed || jump_buffered_timer > 0.0):
			velocity.y = JUMP_VELOCITY;

			jump_buffered = false;
			jump_buffered_timer = 0.0;
			coyote_timer = 0.0;
		elif !jump_buffered:
			jump_buffered = true;
			jump_buffered_timer = JUMP_BUFFER_DURATION;
	elif jump_released:
		velocity.y *= SHORT_HOP_MULTIPLIER;

	if direction == 0: 
		velocity.x = move_toward(velocity.x, WALK_SPEED * direction, RUN_ACCELERATION* 4 * delta)
	else:
		velocity.x = move_toward(velocity.x, WALK_SPEED * direction, RUN_ACCELERATION * delta)
	if !grounded:
		handle_falling(!Input.is_action_pressed("jump"), Input.is_action_pressed("move_down"), delta);


	# Move player
	update();
	move_integer_x(velocity.x * delta);
	move_integer_y(velocity.y * delta);

func handle_falling(fast_fall, hyper_fall, delta):
	var applied_gravity = GRAVITY;
	if velocity.y > 0:
		applied_gravity *= FALLING_MUTIPLIER;
	if fast_fall:
		applied_gravity *= FAST_FALL_MULTIPLIER;
	if hyper_fall:
		applied_gravity *= HYPER_FALL_MULTIPLIER;

	velocity.y = move_toward(velocity.y, MAX_FALL_SPEED, applied_gravity * delta);

var remainder = Vector2.ZERO;
func move_integer_x(delta_x):
	remainder.x += delta_x;
	var move = round(remainder.x);
	remainder.x -= move;

	var step = sign(move);
	while(move != 0):
		global_position.x += step;
		move -= step;

		if is_colliding_with_collidable():
			global_position.x -= step;
			velocity.x = 0
			break;

func move_integer_y(delta_y):
	remainder.y += delta_y;
	var move = round(remainder.y);
	remainder.y -= move;

	var step = sign(move);
	while(move != 0):
		global_position.y += step;
		move -= step;

		if is_colliding_with_collidable():
			global_position.y -= step;
			velocity.y = 0
			break;

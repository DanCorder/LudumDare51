extends Node2D

const GRAVITY = 1000;
const FALLING_MUTIPLIER = 1.25;
const FAST_FALL_MULTIPLIER = 2; # Not holding jump
const HYPER_FALL_MULTIPLIER = 1.25; # Holding down
const SHORT_HOP_MULTIPLIER = 0.7;
const MAX_FALL_SPEED = 1500.0;

const JUMP_HEIGHT = 100.0;
const JUMP_VELOCITY = -sqrt(2.0 * GRAVITY * JUMP_HEIGHT);
const RUN_ACCELERATION = 8000
const WALK_SPEED = 300.0;
const JUMP_BUFFER_DURATION = 0.1;
const COYOTE_BUFFER_DURATION = 0.05;

var velocity = Vector2.ZERO;

var jump_buffered = false;
var jump_buffered_timer = 0.0;
var coyote_timer = 0.0;

var tile_shape;
var collidable_container;
var collision_shape;
onready var main_sprite = $AnimatedSprite
onready var ghost_sprite = $Ghost

var walk_animation = "right-angel"
var jump_animation = "jump-angel"

signal playerDied

var tilemaps = [];

var is_dead;

func _ready():
	collision_shape = $CollisionShape2D.shape;
	collidable_container = get_parent().get_node("collideableTiles");
	tile_shape = collidable_container.shape_owner_get_shape(0, 0);
	tilemaps = get_tilemap_children(collidable_container)
	to_angel()
	is_dead = false;

func get_tilemap_children(parent_node):
	var children = parent_node.get_children();
	var tilemap_children = [];
	
	for child in children:
		if (child is TileMap):
			tilemap_children.append(child);
			
	return tilemap_children;
		
func _process(delta):
	if(!is_dead):
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

		if velocity.y != 0:
			main_sprite.play(jump_animation)
		elif velocity.x != 0:
			main_sprite.play(walk_animation)
			main_sprite.flip_h = velocity.x < 0
		elif velocity.x == 0:
			main_sprite.stop()

		# Move player
		update();
		move_integer_x(velocity.x * delta);
		move_integer_y(velocity.y * delta);

func to_angel():
	walk_animation = "right-angel"
	jump_animation = "jump-angel"
	main_sprite.play(jump_animation)
	main_sprite.stop()
	ghost_sprite.play("jump-devil")
	ghost_sprite.stop()

func to_devil():
	walk_animation = "right-devil"
	jump_animation = "jump-devil"
	main_sprite.play(jump_animation)
	main_sprite.stop()
	ghost_sprite.play("jump-angel")
	ghost_sprite.stop()

func kill():
	emit_signal("playerDied")
	is_dead = true;
	$DeathTimer.start();

func _on_DeathTimer_timeout():
	is_dead = false;

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

		if is_colliding_with_collidable() && !backwards_x_step_is_colliding_with_collidable(step):
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

		if is_colliding_with_collidable() && !backwards_y_step_is_colliding_with_collidable(step):
			global_position.y -= step;
			velocity.y = 0
			break;

func is_colliding_with_collidable():
	for tilemap in tilemaps:
		for tile_pos in tilemap.get_used_cells():
			if collision_shape.collide(transform, tile_shape, Transform2D(0.0, tile_pos * tilemap.cell_size)):
				return true;
	return false;
	
func backwards_y_step_is_colliding_with_collidable(y_step):
	return backwards_step_is_colliding_with_collidable(Vector2(0, y_step))

func backwards_x_step_is_colliding_with_collidable(x_step):
	return backwards_step_is_colliding_with_collidable(Vector2(x_step, 0))
	
func backwards_step_is_colliding_with_collidable(step):
	add_backwards_step(step);
	var is_colliding = is_colliding_with_collidable();
	undo_backwards_step(step);
	return is_colliding;
	
func add_backwards_step(step):
	global_position.x -= step.x;
	global_position.y -= step.y;
	
func undo_backwards_step(step):
	add_backwards_step(-step);

func is_grounded():
	for tilemap in tilemaps:
		for tile_pos in tilemap.get_used_cells():
			if collision_shape.collide_with_motion(transform, Vector2.DOWN, tile_shape, Transform2D(0.0, tile_pos * tilemap.cell_size), Vector2.ZERO):
				coyote_timer = COYOTE_BUFFER_DURATION;
				return true

	if coyote_timer > 0.0:
		return true;
	return false

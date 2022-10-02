extends Area2D

export var leftmost_cell_coords : Vector2;
export var number_of_cells : int;
export var origin_tiles_index: int;
export var destination_tiles_index: int;
export var teleportation_vector : Vector2;
export var cell_height_pixels :  int;
export var can_teleport_only_once : bool;
export var also_teleport_switch : bool;

var tilemap : TileMap;
var is_at_origin_tilemap : bool;
var switch_teleportation_vector : Vector2;

var SWITCH_OFF_TEXTURE = preload("res://switch_off.png");


func _ready():
	tilemap = get_sibling_node("collideableTiles").get_node("TileMap");
	is_at_origin_tilemap = true;
	switch_teleportation_vector = cell_height_pixels * teleportation_vector;
	
func _process(_delta):
	var jump_pressed = Input.is_action_just_pressed("jump")
	if (jump_pressed && is_allowed_to_teleport()):
		teleport_platform();
		if (also_teleport_switch):
			teleport_switch();
		update_tilemap_collision_area();
		update_platform_location_tracker();
		update_switch_ui();

func is_allowed_to_teleport():
	return !can_teleport_only_once || (can_teleport_only_once && is_at_origin_tilemap)

func get_sibling_node(sibling_name):
	return get_parent().get_node(sibling_name);

func update_tilemap_collision_area():
	tilemap.update_dirty_quadrants();
	
func update_switch_ui():
	if (!is_allowed_to_teleport()):
		get_node("Sprite").set_texture(SWITCH_OFF_TEXTURE);

func update_platform_location_tracker():
	is_at_origin_tilemap = !is_at_origin_tilemap;

func teleport_platform():
	for cell_index in number_of_cells:
		var cell_coords = get_platform_cell_coords_by_index(cell_index);
		teleport_cell(cell_coords);

func get_platform_cell_coords_by_index(index):
	return leftmost_cell_coords + Vector2(index,0);

func teleport_switch():
	if (is_at_origin_tilemap):
		teleport_switch_to_destination();
	else:
		teleport_switch_to_origin();
	
func teleport_switch_to_destination():
	position += switch_teleportation_vector;
	
func teleport_switch_to_origin():
	position -= switch_teleportation_vector;
				
func teleport_cell(cell):
	if (is_at_origin_tilemap):
		teleport_cell_to_destination(cell);
	else:
		teleport_cell_to_origin(cell);
	
func teleport_cell_to_destination(cell):
	delete_cell(cell);
	add_cell(cell, destination_tiles_index, teleportation_vector);
	
func teleport_cell_to_origin(cell):
	add_cell(cell, origin_tiles_index);
	delete_cell(cell, teleportation_vector);

func delete_cell(cell, offset_vector = Vector2(0,0)):
	tilemap.set_cell(cell.x + offset_vector.x, cell.y + offset_vector.y, -1);
	
func add_cell(cell, tile_index, offset_vector = Vector2(0,0)):
	tilemap.set_cell(cell.x + offset_vector.x, cell.y + offset_vector.y, tile_index);
	

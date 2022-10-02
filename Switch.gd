extends Area2D

export var platform_coords : Array;
export var origin_tilemap_name : String;
export var origin_tiles_index: int;
export var destination_tilemap_name : String;
export var destination_tiles_index: int;
export var teleportation_vector : Vector2;
export var cell_height_pixels :  int;
export var can_teleport_only_once : bool;
export var also_teleport_switch : bool;

var origin_tilemap : TileMap;
var destination_tilemap : TileMap;
var is_at_origin_tilemap : bool;
var switch_teleportation_vector : Vector2;

var SWITCH_OFF_TEXTURE = preload("res://switch_off.png");


func _ready():
	origin_tilemap = get_sibling_node(origin_tilemap_name);
	destination_tilemap = get_sibling_node(destination_tilemap_name);
	is_at_origin_tilemap = true;
	switch_teleportation_vector = cell_height_pixels * teleportation_vector;
	
func _process(_delta):
	var jump_pressed = Input.is_action_just_pressed("jump")
	if (jump_pressed && is_allowed_to_teleport()):
		teleport_platform();
		if (also_teleport_switch):
			teleport_switch();
		update_tilemaps_collision_area();
		update_platform_location_tracker();
		update_switch_ui();

func is_allowed_to_teleport():
	return !can_teleport_only_once || (can_teleport_only_once && is_at_origin_tilemap)

func get_sibling_node(sibling_name):
	return get_parent().get_node(sibling_name);

func update_tilemaps_collision_area():
	origin_tilemap.update_dirty_quadrants();
	destination_tilemap.update_dirty_quadrants();
	
func update_switch_ui():
	if (!is_allowed_to_teleport()):
		get_node("Sprite").set_texture(SWITCH_OFF_TEXTURE);

func update_platform_location_tracker():
	is_at_origin_tilemap = !is_at_origin_tilemap;

func teleport_platform():
	for cell in platform_coords:
		teleport_cell(cell);

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
	delete_cell_from_tilemap(cell, origin_tilemap);
	add_cell_to_tilemap(cell, destination_tilemap, destination_tiles_index, teleportation_vector);
	
func teleport_cell_to_origin(cell):
	add_cell_to_tilemap(cell, origin_tilemap, origin_tiles_index);
	delete_cell_from_tilemap(cell, destination_tilemap, teleportation_vector);

func delete_cell_from_tilemap(cell, tilemap, offset_vector = Vector2(0,0)):
	tilemap.set_cell(cell.x + offset_vector.x, cell.y + offset_vector.y, -1);
	
func add_cell_to_tilemap(cell, tilemap, tile_index, offset_vector = Vector2(0,0)):
	tilemap.set_cell(cell.x + offset_vector.x, cell.y + offset_vector.y, tile_index);
	

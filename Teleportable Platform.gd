extends Area2D

export var leftmost_cell_coords : Vector2;
export var number_of_cells : int;
export var origin_tiles_index: int;
export var destination_tiles_index: int;
export var teleportation_vector : Vector2;
export var cell_height_pixels :  int;
export var teleport_on_jump : bool;
export var can_teleport_only_once : bool;
export var also_teleport_switch : bool;

var tilemap : TileMap;
var is_at_origin_tilemap : bool;
var switch_teleportation_vector : Vector2;

var SWITCH_ON_TEXTURE = preload("res://assets/switch/switch_on.png");
var SWITCH_OFF_TEXTURE = preload("res://assets/switch/switch_off.png");
var PLAYER_IS_NEAR_SWITCH = false;

func _ready():
	tilemap = get_sibling_node("collideableTiles").get_node("TileMap");
	is_at_origin_tilemap = true;
	switch_teleportation_vector = cell_height_pixels * teleportation_vector;
	set_switch_ui_off();
	if (trigger_mechanic_is_jump()):
		hide_switch();
	
func _process(_delta):
	if (is_teleport_triggered() && is_allowed_to_teleport()):
		teleport_platform();
		if (trigger_mechanic_is_switch() && also_teleport_switch):
			teleport_switch();
		update_tilemap_collision_area();
		update_platform_location_tracker();
		if (trigger_mechanic_is_switch()):
			update_switch_ui();

func is_teleport_triggered():
	if (trigger_mechanic_is_jump()):
		return Input.is_action_just_pressed("jump");
	else:
		return Input.is_action_just_pressed("ui_select") && PLAYER_IS_NEAR_SWITCH;
		
func trigger_mechanic_is_switch():
	return !teleport_on_jump;
	
func trigger_mechanic_is_jump():
	return teleport_on_jump;
	
func hide_switch():
	get_node("Switch").set_texture(null);
	
func is_allowed_to_teleport():
	return !can_teleport_only_once || (can_teleport_only_once && is_at_origin_tilemap)

func get_sibling_node(sibling_name):
	return get_parent().get_node(sibling_name);

func update_tilemap_collision_area():
	tilemap.update_dirty_quadrants();
	
func update_switch_ui():
	if (!is_allowed_to_teleport()):
		hide_switch();
		
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

func _on_Switch_area_entered(area):
	if areaIsPlayer(area):
		PLAYER_IS_NEAR_SWITCH = true;
		if trigger_mechanic_is_switch() && is_allowed_to_teleport():
			set_switch_ui_on();

func _on_Switch_area_exited(area):
	if areaIsPlayer(area):
		PLAYER_IS_NEAR_SWITCH = false;
		if trigger_mechanic_is_switch() && is_allowed_to_teleport():
			set_switch_ui_off();
		
func areaIsPlayer(area):
	return area == get_parent().get_node("playerCharacter");
	
func set_switch_ui_off():
	get_node("Switch").set_texture(SWITCH_OFF_TEXTURE);
	
func set_switch_ui_on():
	get_node("Switch").set_texture(SWITCH_ON_TEXTURE);


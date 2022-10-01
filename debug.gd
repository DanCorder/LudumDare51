extends Area2D
	
var tile_shape;

func _ready():
	tile_shape = shape_owner_get_shape(0, 0);
	
func _draw():
	for tilemap in get_children():
		for tile_pos in tilemap.get_used_cells():
			draw_circle(tile_pos * tilemap.scale * tilemap.cell_size, 5, Color.black);

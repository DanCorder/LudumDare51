extends Area2D

func _on_Win_Area_area_entered(area):
	if area == get_parent().get_node("playerCharacter"):
		var next_level = get_parent().next_level;
		get_parent().get_parent().call_deferred("change_level_to", next_level);

extends Area2D

func _on_Win_Area_area_entered(area):
	if area == get_parent().get_node("Player").get_node("Area2D"):
		print(get_parent().next_level)

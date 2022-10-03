extends Area2D

func _on_Win_Area_area_entered(area):
	if area == get_parent().get_node("playerCharacter"):
		get_tree().change_scene("res://Start screen.tscn")

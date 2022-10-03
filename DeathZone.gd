extends Area2D

func _on_DeathZone_area_entered(area):
	if area.has_method("kill"):
		area.kill()

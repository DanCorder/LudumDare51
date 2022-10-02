extends Control

func _ready():
	$ViewportContainer2/Viewport.world_2d = $ViewportContainer/Viewport.world_2d
	$ViewportContainer/Viewport/Cam.global_position = $ViewportContainer/Viewport/World/Level/MainCameraCenter.global_position
	$ViewportContainer2/Viewport/PreviewCam.global_position = $ViewportContainer/Viewport/World/Level/PreviewCameraCenter.global_position


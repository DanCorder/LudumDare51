extends Control

func _ready():
	$ViewportContainer2/Viewport.world_2d = $ViewportContainer/Viewport.world_2d
	$ViewportContainer/Viewport/Cam.global_position = $ViewportContainer/Viewport/World/Level/MainCameraCenter.global_position
	$ViewportContainer2/Viewport/PreviewCam.global_position = $ViewportContainer/Viewport/World/Level/PreviewCameraCenter.global_position

func _input(event):
	if Input.is_action_pressed("show_map"):
		$ViewportContainer/Viewport/PreviewCam.make_current()	
		$ViewportContainer2/Viewport/Cam.make_current()
	else:
		$ViewportContainer2/Viewport/PreviewCam.make_current()	
		$ViewportContainer/Viewport/Cam.make_current()
		

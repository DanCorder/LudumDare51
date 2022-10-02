extends Node2D


var follow_cam: Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	follow_cam = get_node("/root/Control/ViewportContainer2/Viewport/PreviewCam")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow_cam.global_position = global_position

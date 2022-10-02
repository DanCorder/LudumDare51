extends Node2D


var follow_cam1: Camera2D
var follow_cam2: Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	follow_cam1 = get_node("/root/Control/ViewportContainer2/Viewport/PreviewCam")
	follow_cam2 = get_node("/root/Control/ViewportContainer/Viewport/PreviewCam")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow_cam1.global_position = global_position
	follow_cam2.global_position = global_position

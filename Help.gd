extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$BackButton.grab_focus()

func _on_BackButton_pressed():
	get_tree().change_scene("res://Start screen.tscn")

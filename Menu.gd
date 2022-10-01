extends MarginContainer

func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene("res://fullmap.tscn")
	
func _on_QuitButton_pressed():
	get_tree().quit()


func _on_HelpButton_pressed():
	get_tree().change_scene("res://Help.tscn")

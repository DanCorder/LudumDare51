extends Control

var current_percent_visible_value = 0;
var PERCENT_VISIBLE_INCREMENT = 0.01;

func _ready():
	$BackButton.grab_focus();
	set_text_percent_visible(0);

func _process(_delta):
	if (current_percent_visible_value < 1):
		current_percent_visible_value += PERCENT_VISIBLE_INCREMENT;
		set_text_percent_visible(current_percent_visible_value);

func set_text_percent_visible(value):
	$Title.percent_visible = value;
	$Instructions.percent_visible = value;
	$PlayerControls.percent_visible = value;

func _on_BackButton_pressed():
	get_tree().change_scene("res://Start screen.tscn")



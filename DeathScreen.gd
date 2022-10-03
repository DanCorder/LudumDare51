extends Node2D

var current_percent_visible_value = 0;
var PERCENT_VISIBLE_INCREMENT = 0.03;

func _ready():
	set_text_percent_visible(0);

func _process(_delta):
	if (current_percent_visible_value < 1):
		current_percent_visible_value += PERCENT_VISIBLE_INCREMENT;
		set_text_percent_visible(current_percent_visible_value);

func set_text_percent_visible(value):
	$Heading.percent_visible = value;
	$Subheading.percent_visible = value;

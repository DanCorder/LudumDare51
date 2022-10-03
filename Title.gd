extends Label

func _ready():
	percent_visible = 0;

func _process(_delta):
	if (percent_visible < 1):
		percent_visible += 0.005;

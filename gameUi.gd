extends Control

var timerFont;

var FONT_INCREASE_RATE = 3
var FONT_MAXIMUM_SIZE = 30;

var frame_countdown = FONT_INCREASE_RATE;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.text = "10"
	timerFont = $Timer.get("custom_fonts/font");
	reset_timer_font_size();

func _process(_delta):
	if (frame_countdown == 0):
		if (timerFont.size < FONT_MAXIMUM_SIZE):
			timerFont.size += 1;
		frame_countdown = FONT_INCREASE_RATE;
	else:
		frame_countdown -= 1;

func _on_Node2D_timeUpdate(timeRemaining):
	$Timer.text = "%s" % timeRemaining
	reset_timer_font_size();
	
func reset_timer_font_size():
	timerFont.size = 1;

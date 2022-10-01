extends Control

const timerLabelText = "Time to jump %s"

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerLabel.text = timerLabelText % "10"

func _on_Node2D_timeUpdate(timeRemaining):
	$TimerLabel.text = timerLabelText % timeRemaining

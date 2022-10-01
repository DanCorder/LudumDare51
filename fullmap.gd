extends Node2D

const secondsBetweenSwitching = 10
const tileSize = 64
const mapOffset = 11 * tileSize

signal timeUpdate(timeRemaining)

var secondsOnCurrentLevel = 0
var happyLand = true


# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelSwitchTimer.start()
	$HappyCamera.make_current()


func _on_LevelSwitchTimer_timeout():
	secondsOnCurrentLevel += 1
	if (secondsOnCurrentLevel >= secondsBetweenSwitching):
		secondsOnCurrentLevel = 0
		if (happyLand):
			$SadCamera.make_current()
			happyLand = false
			$Ball.global_position.y += mapOffset
		else:
			$HappyCamera.make_current()
			happyLand = true
			$Ball.global_position.y -= mapOffset
	
	emit_signal("timeUpdate", secondsBetweenSwitching - secondsOnCurrentLevel)

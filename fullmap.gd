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
	$Player/Ghost.global_position.y += mapOffset
	get_parent().get_child(0).make_current()


func _on_LevelSwitchTimer_timeout():
	secondsOnCurrentLevel += 1
	if (secondsOnCurrentLevel >= secondsBetweenSwitching):
		secondsOnCurrentLevel = 0
		if (happyLand):
			$SadMusic.play($HappyMusic.get_playback_position())
			$HappyMusic.stop()
			get_parent().get_child(1).make_current()
			happyLand = false
			$Player.global_position.y += mapOffset
			$Player/Ghost.global_position.y -= 2 * mapOffset
		else:
			$HappyMusic.play($SadMusic.get_playback_position())
			$SadMusic.stop()
			get_parent().get_child(0).make_current()
			happyLand = true
			$Player.global_position.y -= mapOffset
			$Player/Ghost.global_position.y += 2 * mapOffset
	
	emit_signal("timeUpdate", secondsBetweenSwitching - secondsOnCurrentLevel)

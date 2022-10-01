extends Node2D


var happyLand = true
var tileSize = 64
var mapOffset = 11 * tileSize


# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelSwitchTimer.start()
	$HappyCamera.current = true


func _on_LevelSwitchTimer_timeout():
	if (happyLand):
		$SadCamera.current = true
		happyLand = false
		$Ball.global_position.y += mapOffset
	else:
		$HappyCamera.current = true
		happyLand = true
		$Ball.global_position.y -= mapOffset
		

extends Node2D

const secondsBetweenSwitching = 10
const tileSize = 16
const mapOffset = 36 * tileSize

signal timeUpdate(timeRemaining)

var secondsOnCurrentLevel
var happyLand

# Called when the node enters the scene tree for the first time.
func _ready():
	if !happyLand:
		$HappyMusic.play($SadMusic.get_playback_position())
		$SadMusic.stop()

	happyLand = true
	secondsOnCurrentLevel = 0
	
	$LevelSwitchTimer.start()
	$CanvasLayer/Gui._ready()
	$Level/playerCharacter/Ghost.global_position.y += mapOffset
	get_parent().get_child(0).make_current()

func change_level_to(level):
	remove_child($Level)
	var new_level = load(level).instance()
	new_level.set_name("Level");
	add_child(new_level)
	
	_ready();
	
func switch_camera_center():
	var temp_transform = $Level/MainCameraCenter.global_position
	$Level/MainCameraCenter.global_position = $Level/PreviewCameraCenter.global_position
	$Level/PreviewCameraCenter.global_position = temp_transform
	

func _on_LevelSwitchTimer_timeout():
	secondsOnCurrentLevel += 1
	if (secondsOnCurrentLevel >= secondsBetweenSwitching):
		secondsOnCurrentLevel = 0
		if (happyLand):
			$SadMusic.play($HappyMusic.get_playback_position())
			$HappyMusic.stop()
			switch_camera_center()
			happyLand = false
			$Level/playerCharacter.global_position.y += mapOffset
			$Level/playerCharacter.to_devil()
			$Level/playerCharacter/Ghost.global_position.y -= 2 * mapOffset
		else:
			$HappyMusic.play($SadMusic.get_playback_position())
			$SadMusic.stop()
			switch_camera_center()
			happyLand = true
			$Level/playerCharacter.global_position.y -= mapOffset
			$Level/playerCharacter.to_angel()
			$Level/playerCharacter/Ghost.global_position.y += 2 * mapOffset
	
	emit_signal("timeUpdate", secondsBetweenSwitching - secondsOnCurrentLevel)

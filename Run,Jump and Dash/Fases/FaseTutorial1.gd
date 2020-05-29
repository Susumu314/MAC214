extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.play_music("Level1")
	if PlayerInfo.checkpoint == 1:
		$Player.position = $Checkpoints/Checkpoint1.position	
	if PlayerInfo.checkpoint == 2:
		$Player.position = $Checkpoints/Checkpoint2.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

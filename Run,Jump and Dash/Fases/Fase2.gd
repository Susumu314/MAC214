extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerInfo.true_end = true
	MusicPlayer.play_music("Extra")
	if PlayerInfo.checkpoint == 1:
		$Player.position = $Checkpoints/Checkpoint1.position
		$RedPlataform.position.x = $Player.position.x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

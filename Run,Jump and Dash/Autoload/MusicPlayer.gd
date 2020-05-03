extends Node2D

# Declare member variables here. Examples:
# var a = 2
var tocando = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func play(audio):
	if (audio == "Level1"):
		if tocando !="Level1":
			$Level1.play()
			tocando = "Level1"
			
func stop(audio):
	if (audio == "BGM_Cave"):
		$BGM_Cave.stop()
	if (audio == "BGM_Outside"):
		$BGM_Outside.stop()
	else:
		pass

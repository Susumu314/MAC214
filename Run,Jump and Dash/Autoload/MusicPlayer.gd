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
func play_music(audio):
	if audio != tocando:
		stop_music(tocando)
		for child in $Music.get_children():
			if child.name == audio:
				child.play()
				tocando = audio
				
func play_sfx(audio):
	for child in $SFX.get_children():
		if child.name == audio:
			child.play()	
			
func stop_music(audio):
	for child in $Music.get_children():
		if child.name == audio:
			child.stop()

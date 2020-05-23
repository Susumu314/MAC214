extends Node2D

var timer = 0.0
export var next_scene = ""
func _ready():
	PlayerInfo.Stop_Timer();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if (timer > 8):
		PlayerInfo.Start_Timer()
		$SceneTransition.change_scene(next_scene)

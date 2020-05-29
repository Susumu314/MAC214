extends Control

func _ready():
	PlayerInfo.Stop_Timer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RichTextLabel.set_text("		  Time:" + str(int(PlayerInfo.timer))+ "\n		  Crystals:" + str(int(PlayerInfo.collectables.size())) + "/6"+ "\n		  Deaths:" + str(int(PlayerInfo.deaths))+ "\n		  Press Start")
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().quit()
	pass

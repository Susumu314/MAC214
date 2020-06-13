extends Control

var total_collectables = 0

func _ready():
	PlayerInfo.Stop_Timer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RichTextLabel.set_text("		  Time:" + str(int(PlayerInfo.timer))+ "\n		  Crystals:" + str(int(PlayerInfo.collectables.size())) + "/" + str(total_collectables) + "\n		  Deaths:" + str(int(PlayerInfo.deaths))+ "\n		  Press Start")
	if (Input.is_action_just_pressed("ui_accept")):
		if int(PlayerInfo.collectables.size()) == total_collectables:
			$SceneTransition.change_scene("res://Fases/Fase2Prelude.tscn")
		else:
			get_tree().quit()
	pass

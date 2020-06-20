extends Control

var total_collectables = 7

func _ready():
	PlayerInfo.Stop_Timer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RichTextLabel.set_text("		  Time:" + str(int(PlayerInfo.timer))+ "\n		  Crystals:" + str(int(PlayerInfo.collectables.size())) + "/" + str(total_collectables) + "\n		  Deaths:" + str(int(PlayerInfo.deaths))+ "\n		  Press Start")
	if !PlayerInfo.true_end:
		if (Input.is_action_just_pressed("ui_accept")):
			$SceneTransition.change_scene("res://Fases/Fase2Prelude.tscn")
		if (Input.is_action_just_pressed("Secret")):
			$SceneTransition.change_scene("res://Fases/Fase2Prelude.tscn")
	else:
		if (Input.is_action_just_pressed("ui_accept")):
			get_tree().quit()
		if (Input.is_action_just_pressed("Secret")):
			get_tree().quit()

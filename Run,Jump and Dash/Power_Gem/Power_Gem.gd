extends Area2D


# Declare member variables here. Examples:
# var a = 2
var player
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$Sprite.visible:
		if !player.power_gem:
			timer += delta
			if timer > 0.5:
				$Sprite.visible = true
				timer = 0


func _on_Area2D_body_entered(body):
	if body.has_method("power_gem"):
		player = body
		if $Sprite.visible:
			player.power_gem()
			MusicPlayer.play_sfx("Recovery")
		$Sprite.visible = false

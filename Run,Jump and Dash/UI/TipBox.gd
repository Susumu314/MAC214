extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var text = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel.visible = false
	$RichTextLabel.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		$RichTextLabel.visible = true


func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		$RichTextLabel.visible = false

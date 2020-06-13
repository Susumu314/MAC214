extends Node2D


# Declare member variables here. Examples:
export var xspeed = 500
export var yspeed = 500
var move = false
var on_screen = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_offscreen():
	return !on_screen

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if move:
		self.position += Vector2(xspeed*delta, yspeed*delta)


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		move = true


func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false

func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true

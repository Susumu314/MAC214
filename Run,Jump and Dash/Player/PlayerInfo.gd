extends Node

var Lives = 3
var Score = 0
var timer = 0
var deaths = 0
var start = false
var checkpoint = 0
var collectables = [];
var camera_position = Vector2(0,00)
var true_end = false

func Start_Timer():
	start = true

func Stop_Timer():
	start = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func collect(name):
	collectables.append(name)
	MusicPlayer.play_sfx("Collect")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start:
		timer += delta
	pass

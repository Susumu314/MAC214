extends Node2D

const IDLE_DURATION = 1.0

export(int) var dx
export(int) var dy
export(int) var speed

var move_to = Vector2.ZERO
var follow = Vector2.ZERO

onready var platform = $Platform
onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	move_to = Vector2(dx, dy)
	_init_tween()

func _init_tween():
	var duration = move_to.length()/ float(speed)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION)
	tween.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)

extends KinematicBody2D

const UP = Vector2(0, -1)
var player
export var start_offset = Vector2(-1920, 0)
export var MAX_SPEED_OFFSET = 0.5
export var max_speed_distance = 1920
var speed = 0
var dir = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	position = player.position + start_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir = (player.position - position).normalized()
	speed = player.speed*(0.5 + MAX_SPEED_OFFSET*((position.distance_to(player.position)-960)/max_speed_distance))
	move_and_slide(dir*speed,UP)


func _on_Area2D_body_entered(body):
	if body.has_method("dead"):
		body.dead()

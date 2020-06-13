extends Area2D

export var speed = 800
var target = null
var dir = null
var life_time = 10
var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	timer += delta
	if timer > life_time:
		queue_free()
	if dir == null:
		dir = target - global_position
		dir = dir.normalized()
	global_position += dir*speed*delta


func _on_Bullet_body_entered(body):
	if "Player" in body.name:
		body.Damage()
		queue_free()

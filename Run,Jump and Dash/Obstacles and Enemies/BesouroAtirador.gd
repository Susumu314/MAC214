extends KinematicBody2D

const tag = "enemy"
const UP = Vector2(0,-1) #normal do solo
export(int) var SPEED 
export(int) var dx 
export(int) var dy 
var velocity = Vector2()
var ancora_transform
var ancora_pos = Vector2()
var modo
var BULLET = preload("res://Obstacles and Enemies/Bullet.tscn")
var player = null
var timer = 1.5

func atacar():
	if player != null:
		var bullet = BULLET.instance()
		bullet.set_transform(get_node("Position2D").get_global_transform())
		get_parent().add_child(bullet)
		bullet.target = player.global_position

func _break():
	$CollisionShape2D.disabled = true
	MusicPlayer.play_sfx("Beatle")
	queue_free()

func _ready():
	velocity = Vector2(dx, dy).normalized()*SPEED
	ancora_transform = get_node("ancora").get_global_transform()
	ancora_pos = ancora_transform[2]
	print(ancora_pos)

func _process(delta):
	if dx == 0:
		if position.y - ancora_pos.y > dy:
			velocity.x = -velocity.x
			velocity.y = -velocity.y
		if position.y - ancora_pos.y < 0 && velocity.y < 0:
			velocity.x = -velocity.x
			velocity.y = -velocity.y
	else:
		if position.x - ancora_pos.x > dx:
			velocity.x = -velocity.x
			velocity.y = -velocity.y
		if position.x - ancora_pos.x < 0 && velocity.x < 0:
			velocity.x = -velocity.x
			velocity.y = -velocity.y
	var c = move_and_collide(velocity)
	if c:
		if "Player" in c.get_collider().name:
			if !c.get_collider().isDashing:
				c.get_collider().Damage()
	if timer < 20:
		timer += delta
	if timer >= 0.8 && player != null:
		atacar()
		timer = 0

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		player = body



func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		player = null

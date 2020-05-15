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

func _break():
	$CollisionShape2D.disabled = true
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


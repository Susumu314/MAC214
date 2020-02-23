extends KinematicBody2D


const UP = Vector2(0,-1) #normal do solo
const GRAVITY = 100
const MAX_FALL_SPEED = 2000
var velocity = Vector2()
var dead = false

var dir = Vector2()
var speed = 1200
var jumpForce = 2200
var slideSpeed = 600
var wallJumpLerp = 1200
var dashSpeed = 2400
var canMove = true
var wallGrab = false
var wallJumped = false
var wallSlide = false
var isDashing = false
var can_jump = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func Walk(dir, delta):
	if !canMove:
		return
	
	if wallGrab:
		return
	
	if !wallJumped:
		velocity = Vector2(dir.x * speed, velocity.y)
	else:
		velocity = velocity.linear_interpolate(Vector2(dir.x * speed, velocity.y), wallJumpLerp * delta)

func jump():
	if is_on_floor():
		velocity.y = 5 #para nao ganhar velocidade de queda no solo e para nao bugar o is_on_floor
		if can_jump:
			if Input.is_action_pressed("jump"):
				velocity.y = -jumpForce
				can_jump = false
	if !can_jump:
		if Input.is_action_just_released("jump"):
			can_jump = true
			if velocity.y < 0:
				velocity.y = 0
	if is_on_ceiling():
		velocity.y = +1
		
func _physics_process(delta):
	velocity.y = min(velocity.y + GRAVITY, MAX_FALL_SPEED)
	dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	jump()
	Walk(dir, delta)
	move_and_slide(velocity, UP)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

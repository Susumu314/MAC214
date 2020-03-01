extends KinematicBody2D


const UP = Vector2(0,-1) #normal do solo
const GRAVITY = 150
const MAX_FALL_SPEED = 3000
var velocity = Vector2()
var dead = false

var dir = Vector2()
var speed = 1500
var jumpForce = 3000
var slideSpeed = 600
var wallJumpLerp = 1200
var dashSpeed = 2400
var power_gem = false
var canMove = true
var wallGrab = false
var wallJumped = false
var wallSlide = false
var isDashing = false
var can_jump = false
var leftplataform = 0.0 #usado para permitir que o player pule logo apos sair de uma plataforma


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
	if leftplataform <0.1:
		if can_jump:
			if Input.is_action_pressed("jump"):
				velocity.y = -jumpForce
				can_jump = false
	elif power_gem && can_jump:
			if Input.is_action_pressed("jump"):
				velocity.y = -jumpForce
				can_jump = false
				power_gem = false
	if !can_jump:
		if Input.is_action_just_released("jump"):
			can_jump = true
			if velocity.y < 0:
				velocity.y = 0
	if is_on_ceiling():
		velocity.y = +1

func coyote_time(delta):
	if !is_on_floor():
		leftplataform += delta
	if is_on_floor():
		leftplataform = 0
		
func dead():
	get_tree().reload_current_scene()

func power_gem():
	power_gem = true

func animations(anim):
	$Sprite/AnimationPlayer.play(anim)
func _physics_process(delta):
	coyote_time(delta)
	velocity.y = min(velocity.y + GRAVITY, MAX_FALL_SPEED)
	dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	jump()
	Walk(dir, delta)
	move_and_slide(velocity, UP)
	for i in get_slide_count():
		if get_slide_collision(i).collider.name == "Spikes":
			dead()
	if power_gem:
		animations("Power_Gem_Idle")
	else:
		animations("Idle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
var dashSpeed = 4500
var power_gem = false
var canMove = true
var wallGrab = false
var wallJumped = false
var wallSlide = false
var isDashing = false
var can_jump = true
var timer_dash = 0.0
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
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jumpForce
	elif power_gem:
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jumpForce
				power_gem = false
	if Input.is_action_just_released("jump"):
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

func dash(delta):#personagem dá um dash na direcao que o player esta segurando, priorizando as direcoes verticais e quebra paredes e mata monstros ao contato
	if power_gem:
		if !isDashing:
			if Input.is_action_just_pressed("dash_attack"):
				power_gem = false
				if dir.y >= 0.87:
					velocity = Vector2(0, 1) * dashSpeed 
					isDashing = true
					animations("Dash_r")
					$Sprite.rotation_degrees = 90
					return
				if dir.y <= -0.87:
					velocity = Vector2(0, -1) * dashSpeed
					isDashing = true
					animations("Dash_r")
					$Sprite.rotation_degrees = 270
					return
				if dir.x >= 0.5:
					velocity = Vector2(1, 0) * dashSpeed
					isDashing = true
					animations("Dash_r")
					return
				if dir.x <= -0.5:
					velocity = Vector2(-1, 0) * dashSpeed
					isDashing = true
					animations("Dash_r")
					$Sprite.rotation_degrees = 180
					return
	if isDashing:
		timer_dash += delta
		if timer_dash > 0.1:
			isDashing = false
			timer_dash = 0
			if velocity.y < 0:
				velocity = Vector2(0, -jumpForce*0.4)
			elif velocity.y > 0:
				pass
			else:
				velocity = Vector2(0,0)
					
				
func animations(anim):
	$Sprite/AnimationPlayer.play(anim)
	
	
func _physics_process(delta):
	coyote_time(delta)
	dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	if !isDashing:
		$Sprite.rotation_degrees = 0
		Walk(dir, delta)
		velocity.y = min(velocity.y + GRAVITY, MAX_FALL_SPEED)
		jump()
		if power_gem:
			animations("Power_Gem_Idle")
		else:
			animations("Idle")
	dash(delta)
	
	var collision = move_and_collide(velocity * delta,true, true, true)
	if collision:
		if collision.collider.has_method("_break") && isDashing:
			if "Power" in collision.collider.name:
				power_gem()
			collision.collider._break()
	move_and_slide(velocity, UP)
	for i in get_slide_count():
		if get_slide_collision(i).collider.name == "Spikes":
			dead()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends KinematicBody2D


var UP = Vector2(0,-1) #normal do solo
const GRAVITY = 150
const MAX_FALL_SPEED = 3000
var velocity = Vector2()
var dead = false

var last_dir = Vector2()
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
var snap
var walldir = 0.0
var timer_dash = 0.0
var timer_wallJump = 0.0
var timer_wallGrab = 0.0
var leftplataform = 0.0 #usado para permitir que o player pule logo apos sair de uma plataforma


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func Walk(dir, delta):
	if !canMove:
		return
	if wallGrab:
		return
	if wallJumped:
		return
	if is_on_floor():
		if get_floor_normal() != Vector2(0, -1):
			velocity = Vector2(dir.x * speed * get_floor_normal().y, dir.x*speed*get_floor_normal().x)
		else:
			velocity.y = 5 #para nao ganhar velocidade de queda no solo e para nao bugar o is_on_floor

	velocity = Vector2(dir.x * speed, velocity.y)
		
	#else:
	#	velocity = velocity.linear_interpolate(Vector2(dir.x * speed, velocity.y), wallJumpLerp * delta)

func jump():
	if timer_wallGrab < 0.1:
		if Input.is_action_just_pressed("jump"):
			velocity.y = -sin(PI/3)*jumpForce
			velocity.x = -cos(PI/3)*jumpForce*walldir
			wallGrab = false
			wallJumped = true
			return
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
	if dir != Vector2(0,0):
		last_dir = dir
	if power_gem:
		if !isDashing:
			if Input.is_action_just_pressed("dash_attack"):
				power_gem = false
				if last_dir.y >= 0.87:
					velocity = Vector2(0, 1) * dashSpeed 
					isDashing = true
					animations("Dash_r")
					$Sprite.rotation_degrees = 90
					return
				if last_dir.y <= -0.87:
					velocity = Vector2(0, -1) * dashSpeed
					isDashing = true
					animations("Dash_r")
					$Sprite.rotation_degrees = 270
					return
				if last_dir.x >= 0.5:
					velocity = Vector2(1, 0) * dashSpeed
					isDashing = true
					animations("Dash_r")
					return
				if last_dir.x <= -0.5:
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
		var collision = move_and_collide(velocity * delta,true, true, true) #testa colisao para quebrar objetos sem interferir com o movimento do player
		if collision:
			if collision.collider.has_method("_break") && isDashing:
				if "Power" in collision.collider.name:
					power_gem()
				if "Enemy" in collision.collider.name:
					bounce()
				collision.collider._break()
				
					
				
func animations(anim):
	$Sprite/AnimationPlayer.play(anim)
	
func bounce():
	isDashing = false
	timer_dash = 0
	velocity = Vector2(0,-jumpForce)

func wall_grab(delta):
	wallGrab = false
	if wallJumped:
		timer_wallJump += delta
		if timer_wallJump > 0.28:
			wallJumped = false
			timer_wallJump = 0.0
	if is_on_wall():
		if $Direita.is_colliding() && "Sticky" in $Direita.get_collider().name:
			if dir.x > 0.5:
				wallGrab = true
				walldir = 1;
		if $Esquerda.is_colliding() && "Sticky" in $Esquerda.get_collider().name:
			if dir.x < -0.5:
				wallGrab = true
				walldir = -1
	if wallGrab && !wallJumped:
		velocity.y = 0
	if wallGrab:
		timer_wallGrab = 0.0
	elif timer_wallGrab < 0.3 :
		timer_wallGrab += delta

func move():
	if $Down.is_colliding():
		if $Down.get_collider().is_in_group("platforms"):
			snap = Vector2.DOWN * 10
		else:
			 Vector2.ZERO
	else:
		snap = Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, UP)
	for i in get_slide_count():
		var collider = get_slide_collision(i).collider
		if collider.name == "Spikes":
			dead()
		if "Enemy" in collider.name && !isDashing:
			dead()
		
		
func _physics_process(delta):
	coyote_time(delta)
	dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	if !isDashing:
		$Sprite.rotation_degrees = 0
		Walk(dir, delta)
		velocity.y = min(velocity.y + GRAVITY, MAX_FALL_SPEED)
		jump()
		wall_grab(delta)
		if power_gem:
			animations("Power_Gem_Idle")
		else:
			animations("Idle")
	dash(delta)
	move()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

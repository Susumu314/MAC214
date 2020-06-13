extends KinematicBody2D


var UP = Vector2(0,-1) #normal do solo
const GRAVITY = 150
const MAX_FALL_SPEED = 3000
var velocity = Vector2()
var dead = false

var last_dir = Vector2()
var dir = Vector2()
var speed = 1500
var ACCEL = 10*speed;#demora 1/10 segundos para velocidade maxima
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
var pivots = [] 
var swinging = false
var pivot_prox = null
var d
var recovety_rate = 300 # 300/segundo
var timer = 0
var shield = true
var shield_recovery = 50# 150/segundo
var i_frames = 0.5 # 1/3 de segundos que fica sem tomar dano
var i_timer = 0.51
var stun = false

func Hurt():
	if i_timer <= i_frames*0.5:
		stun = true
		velocity = Vector2(-last_dir.x * speed * 0.5, 0)
		if $Sprite.visible:
			$Sprite.visible = false
		else:
			$Sprite.visible = true
	else:
		stun = false
		if !$Sprite.visible:
			$Sprite.visible = true

# Called when the node enters the scene tree for the first time.
func invincibility(delta):
	if i_timer <= i_frames:
		i_timer = i_timer + delta
		
func _ready():
	timer = PlayerInfo.timer
	$HUD/ShieldBar/PowerBar.value = 100
	pass # Replace with function body.
	
func Damage():
	if i_timer > i_frames:
		if shield:
			MusicPlayer.play_sfx("ShieldDamage")
			shield = false
			$HUD/ShieldBar/PowerBar.value = 99
			$HUD/ShieldBar._on_power_updated(0)
			$Shield.visible = false
			i_timer = 0;
		else:
			dead()

func Recover_Shield(delta):
	if is_on_floor() && velocity.x == 0:
		if $HUD/ShieldBar/PowerBar.value < 100:
			$HUD/ShieldBar/PowerBar.value += shield_recovery*delta
		elif !shield:
			shield = true
			$Shield.visible = true
			MusicPlayer.play_sfx("ShieldRecovery")
			
func PowerParticles():
	if power_gem && !$Particles2D.emitting:
		$Particles2D.emitting = true
		$Particles2D.visible = true
	if !power_gem:
		$Particles2D.emitting = false
		$Particles2D.visible = false
		
func Walk(delta):
	if !canMove || wallJumped || wallGrab || swinging || stun:
		return
	if is_on_floor():
		# nesse pedaço refazer o codigo de andar no slope de algum jeito, pq isso aqui tava bugando ocodigo de aceleracao
#		if get_floor_normal() != Vector2(0, -1):
#			velocity = Vector2(dir.x * speed * get_floor_normal().y, dir.x*speed*get_floor_normal().x)
#		else:
			velocity.y = 5 #para nao ganhar velocidade de queda no solo e para nao bugar o is_on_floor
	
	if dir.x > 0:
		if velocity.x >= 0:
			velocity.x = min(speed, velocity.x + dir.x*ACCEL*delta)
		else:
			velocity.x = 0
	elif dir.x < 0:
		if velocity.x <= 0:
			velocity.x = max(-speed, velocity.x + dir.x*ACCEL*delta)
		else:
			velocity.x = 0
	else:
		if velocity.x > 0:
			velocity.x = max(0, velocity.x - ACCEL*delta)
		if velocity.x < 0:
			velocity.x = min(0, velocity.x + ACCEL*delta)
		
	#else:
	#	velocity = velocity.linear_interpolate(Vector2(dir.x * speed, velocity.y), wallJumpLerp * delta)

func jump():
	if swinging || stun:
		return
	if timer_wallGrab < 0.2:
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
				use_power()
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
	PlayerInfo.deaths += 1
	get_tree().reload_current_scene()

func power_gem():
	power_gem = true

func use_power():
	power_gem = false
	$HUD/PowerBar._on_power_updated(0)
	
	
func dash(delta):#personagem dá um dash na direcao que o player esta segurando, priorizando as direcoes verticais e quebra paredes e mata monstros ao contato
	if swinging || stun:
		return
	if dir != Vector2(0,0):
		last_dir = dir
	if power_gem:
		if !isDashing:
			if Input.is_action_just_pressed("dash_attack"):
				use_power()
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
					MusicPlayer.play_sfx("Recovery")
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
	if swinging || stun:
		return
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
			 snap = Vector2.ZERO
	else:
		snap = Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, UP)
	for i in get_slide_count():
		var collider = get_slide_collision(i).collider
		if collider.name == "Spikes":
			Damage()
		if "Enemy" in collider.name && !isDashing:
			Damage()
			
func suicide():
	if (Input.is_action_just_pressed("suicidio")):
		dead()

func Reset_Power():
	if power_gem && $HUD/PowerBar/PowerBar.value < 100:
		$HUD/PowerBar.reset_power_to_max()

func Reset_Shield():
	if power_gem && $HUD/PowerBar/PowerBar.value < 100:
		$HUD/PowerBar.reset_power_to_max()

func _physics_process(delta):
	Reset_Shield()
	Reset_Power()
	coyote_time(delta)
	dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	if !isDashing && !swinging:
		$Sprite.rotation_degrees = 0
		Walk(delta)
		velocity.y = min(velocity.y + GRAVITY, MAX_FALL_SPEED)
		jump()
		wall_grab(delta)
		if power_gem:
			animations("Power_Gem_Idle")
		else:
			animations("Idle")
	dash(delta)
	move()
	swing(delta)
	charge_power(delta)
	invincibility(delta)
	Recover_Shield(delta)
	Hurt()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	$HUD/Timer.set_text(str(int(timer)))
	suicide()
	PowerParticles()
	pass

func swing(delta):
	if stun:
		swinging = false
		pivot_prox = null
		return
	if (Input.is_action_just_pressed("swing")):
		get_pivot()
		if (pivot_prox != null):
			d = position.distance_to(pivot_prox.global_position)
			set_velocity()
	if (Input.is_action_just_released("swing")):
		swinging = false
		pivot_prox = null
	show_hook(pivot_prox)
	if (pivot_prox != null && swinging):
		if is_on_ceiling() || is_on_wall() || is_on_floor():
			velocity.y = -velocity.y
			velocity.x = -velocity.x
			if velocity.x > speed:
				velocity.x = speed
			if velocity.y > speed:
				velocity.y = speed
		var sen = (position.x - pivot_prox.global_position.x )/d
		var cossen = (position.y - pivot_prox.global_position.y )/d
		var new_velocity = Vector2(velocity.x  - velocity.length_squared()*sen*delta/d, velocity.y  - velocity.length_squared()*delta*cossen/d)
		velocity = new_velocity
func get_pivot():
	var i = 0
	while(i < pivots.size()):
		if (pivot_prox == null):
			pivot_prox = pivots[i]
		else:
			if (position.distance_to(pivots[i].global_position) < position.distance_to(pivot_prox.global_position)):
				pivot_prox = pivots[i]
		i = i + 1
	if (pivot_prox != null): #se tiver um pivot proximo. jogar arpao
		print(pivot_prox)
		swinging = true 

func set_velocity():
	var new_velocity
	var velocidade = velocity.length()
	if velocidade < 0.2 * speed:
		velocidade = 0.2 * speed
	var sen = (position.x - pivot_prox.global_position.x )/d
	var cossen = (position.y - pivot_prox.global_position.y)/d
	if sen > 0:
		if (velocity.x > 0.2 * speed && cossen > 0) || (velocity.x < -0.5 * speed && -cossen > 0.71): 
			new_velocity = Vector2(velocidade*cossen, -velocidade * sen)
		else:
			new_velocity = Vector2(-velocidade*cossen, velocidade * sen)
	else:
		if (velocity.x < -0.2 * speed && cossen > 0) || (velocity.x > 0.5 * speed && -cossen > 0.71):
			new_velocity = Vector2(-velocidade*cossen, velocidade * sen)
		else:
			new_velocity = Vector2(velocidade*cossen, -velocidade * sen)
	velocity = new_velocity

func show_hook(pivot):
	$Hook.clear_points()
	$Hook.global_position = Vector2.ZERO
	$Hook.global_rotation = 0
	if (pivot_prox != null && swinging):
		$Hook.add_point(pivot.global_position)
		$Hook.add_point(position)

func charge_power(delta):
	if is_on_floor() && !isDashing: #&& dir.x == 0:
		if $HUD/PowerBar/PowerBar.value < 100:
			$HUD/PowerBar/PowerBar.value += recovety_rate*delta
		elif !power_gem:
			power_gem()
			

func _on_Area2D_area_entered(area):
	if "Pivot" in area.name:
		pivots.append(area)
		area.get_child(1).modulate = Color(1, 1, 1)


func _on_Area2D_area_exited(area):
	if "Pivot" in area.name:
		pivots.erase(area)
		area.get_child(1).modulate = Color(0,835,1, 1)

extends KinematicBody2D

#PHYSICS VARIABLES
var GRAVITY = 10
var MAX_SPEED = 100
var ACCEL = 50
var JUMP_HEIGHT = 250
var WALL_SLIDE_ACCEL = 10
var WALL_SLIDE_MAX_SPEED = 40
var velocity = Vector2.ZERO
var friction = false
#STATE MACHINE VARIABLES
var current_state := 0
enum { IDLE, ATTACK, RUN, JUMP, FALL, CROUCH, SLIDE, RUSH, WALL_SLIDE, D_JUMP, CROUCH_RUN, HURT, DEAD, EXIT, DEFENSE, CAST_CHARGE, CAST }
var enter_state := true
#MISC VARIABLES
var canjump = true
var p_input = true
var attack_points = 3
var attack = false
var can_hurt = true
var dead = false
var hit = false
var exit = false
var exit_dir = null
var can_shot = true 
#NODE VARIABLES
onready var sprite = $sprite
onready var jump_timer = $jumpbuffer_timer
onready var coyote_timer = $coyote_timer
onready var dash_timer = $dash_timer
onready var attack_timer = $attackreset_timer
onready var knockback_timer = $knockback_timer
onready var raycast_wall1 = $Wall_raycast/raycast_wall1
onready var raycast_wall2 = $Wall_raycast/raycast_wall2
onready var raycast_wall3 = $Wall_raycast/raycast_wall3
onready var raycast_wall4 = $Wall_raycast/raycast_wall4
onready var raycast_wall5 = $Wall_raycast/raycast_wall5
onready var exit_raycastR = $Exit_raycasts/exit_raycastR
onready var exit_raycastL = $Exit_raycasts/exit_raycastL
onready var col_stand = $Collision_stand
onready var col_slide = $Collision_slide
onready var col_crouch = $Collision_crouch
onready var hitbox_attack = $Hitbox/Attack_hitbox
onready var hurtbox = $hurtbox/collision
onready var particle_charge = $Particles2D
onready var camera = $Camera2D
onready var partner = $partner
onready var audio_manager = $audio_manager
onready var hit_fx = preload("res://Prefabs/fx_hit.tscn")
onready var fireball = preload("res://Prefabs/Fire_ball.tscn")
#SOUND_FX VARIABLES
var sfx_jump : AudioStream = load("res://Sounds/SFX/hero_jump.wav")
var sfx_attack1 : AudioStream = load("res://Sounds/SFX/hero_atk1.wav")
var sfx_attack2 : AudioStream = load("res://Sounds/SFX/hero_atk2.wav")
var sfx_attack3 : AudioStream = load("res://Sounds/SFX/hero_atk3.wav")
var sfx_attack1air : AudioStream = load("res://Sounds/SFX/hero_atk1_air.wav")
var sfx_attack2air : AudioStream = load("res://Sounds/SFX/hero_atk2_air.wav")
var sfx_attack3air : AudioStream = load("res://Sounds/SFX/hero_atk3_air.wav")
var sfx_rush : AudioStream = load("res://Sounds/SFX/hero_rush.wav")
var sfx_hurt : AudioStream = load("res://Sounds/SFX/hero_hurt.wav")
var sfx_djump : AudioStream = load("res://Sounds/SFX/hero_djump.wav")
var sfx_die : AudioStream = load("res://Sounds/SFX/hero_die.wav")
var sfx_slide : AudioStream = load("res://Sounds/SFX/hero_slide.wav")
var sfx_wallslide : AudioStream = load("res://Sounds/SFX/hero_wallslide.wav")
var sfx_damage : AudioStream = load("res://Sounds/SFX/raclure - Damage SFX.wav")
var sfx_guard : AudioStream = load("res://Sounds/SFX/Shield_guard - by Reaper.wav")
var sfx_collect : AudioStream = load("res://Sounds/SFX/axilirate_collect_crystal.wav")
#SIGNALS
signal damaged
signal cast
#----------------------------------------------------------------------------------------------------------------------------------------------------------------
#PROCESSO AO INICIAR---------------------------------------------------------------------------------------------------------------------------------------------
func _ready():
	
	Global.register_player(self, partner)
	self.global_position = Global.player_inial_map_position
	if Global.player_facing_direction == 1:
		sprite.flip_h = false
	elif Global.player_facing_direction == -1:
		sprite.flip_h = true
	
	var tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_node("TileMap").cell_size
	camera.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	camera.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	camera.limit_top = tilemap_rect.position.y * tilemap_cell_size.y
	camera.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
	
	
	
	
#PROCESSO DE FÍSICA---------------------------------------------------------------------------------------------------------------------------------------------
func _physics_process(delta):
	
	get_parent().connect("force_idle", self, "force_idle")
	
	match current_state:
		IDLE:
			idle_state(delta)
		ATTACK:
			attack_state(delta)
		RUN:
			run_state(delta)
		JUMP:
			jump_state(delta)
		FALL:
			fall_state(delta)
		CROUCH:
			crouch_state(delta)
		SLIDE:
			slide_state(delta)
		RUSH:
			rush_state(delta)
		WALL_SLIDE:
			wall_slide(delta)
		D_JUMP:
			doublejump_state(delta)
		CROUCH_RUN:
			crouchrun_state(delta)
		HURT:
			hurt_state(delta)
		DEAD:
			dead_state(delta)
		EXIT:
			exit_state(delta)
		DEFENSE:
			defense_state(delta)
		CAST_CHARGE:
			castcharge_state(delta)
		CAST:
			cast_state(delta)
	
	if current_state == CROUCH_RUN:
		MAX_SPEED = 50
		ACCEL = 25
	else:
		MAX_SPEED = 100
		ACCEL = 50

	
	change_color()

func _process(delta):
	if Global.dialogue_happen == true:
		set_physics_process(false)
	elif Global.dialogue_happen == false:
		set_physics_process(true)

#STATES---------------------------------------------------------------------------------------------------------------------------------------------
func idle_state(_delta):
	sprite.play("idle")
	_gravity(_delta)
	particle_charge.visible = false
	particle_charge.emitting = false
	JUMP_HEIGHT = 250
	velocity.x = lerp(velocity.x, 0, 0.3)
	_move_and_slide()
	_collision_handler()
	set_state(check_idle_state())

func attack_state(_delta):
	velocity.x = 0
	
	if attack_points == 1:
		velocity.y += GRAVITY
	else:
		velocity.y = min(velocity.y+10, 40)
		
	if is_on_floor():
		if attack_points == 3:
			attack_timer.start()
			if attack == false:
				audio_manager.play_sfx(sfx_attack1)
				sprite.play("attack1")
				attack = true
		elif attack_points == 2:
			attack_timer.start()
			if attack == false:
				audio_manager.play_sfx(sfx_attack2)
				sprite.play("attack2")
				attack = true
		elif attack_points == 1:
			attack_timer.start()
			if attack == false:
				audio_manager.play_sfx(sfx_attack3)
				sprite.play("attack3")
				attack = true
				Global.frame_freeze(0.5, 0.4)
	elif !is_on_floor():
		if attack_points == 3:
			attack_timer.start()
			if attack == false:
				audio_manager.play_sfx(sfx_attack1air)
				sprite.play("attack_air1")
				attack = true
		elif attack_points == 2:
			attack_timer.start()
			if attack == false:
				audio_manager.play_sfx(sfx_attack2air)
				sprite.play("attack_air2")
				attack = true
		elif attack_points == 1:
			attack_timer.start()
			if attack == false:
				audio_manager.play_sfx(sfx_attack3air)
				sprite.play("attack_air3")
				attack = true
		
	_collision_handler()
	_move_and_slide()
		
func run_state(_delta):
	sprite.play("run")
	if p_input:
		_move()
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()
	set_state(check_run_state())

func jump_state(_delta):
	if enter_state:
		audio_manager.play_sfx(sfx_jump)
		sprite.play("jump")
		velocity.y = -JUMP_HEIGHT
		enter_state = false
	velocity.x = lerp(velocity.x, 0, 0.1)
	_gravity(_delta)
	if p_input:
		_move()
	_move_and_slide()
	_collision_handler()
	set_state(check_jump_state())

func fall_state(_delta):
	sprite.play("fall")
	JUMP_HEIGHT = 250
	velocity.x = lerp(velocity.x, 0, 0.1)
	_gravity(_delta)
	if p_input:
		_move()
	_move_and_slide()
	_collision_handler()
	set_state(check_fall_state())

func crouch_state(_delta):
	sprite.play("crouch")
	velocity.x = 0
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()
	set_state(check_crouch_state())

func slide_state(_delta):
	sprite.play("slide")
	if enter_state:
		audio_manager.play_sfx(sfx_slide)
		if sprite.flip_h == false:
			velocity.x = MAX_SPEED*2
		elif sprite.flip_h == true:
			velocity.x = -MAX_SPEED*2
		enter_state = false
	_gravity(_delta)
	_move_and_slide()
	velocity.x = lerp(velocity.x, 0, 0.03)
	_collision_handler()
	set_state(check_slide_state())

func rush_state(_delta):
	sprite.play("rush")
	if enter_state:
		audio_manager.play_sfx(sfx_rush)
		enter_state = false
	#	Movimento Esquerda
	if Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x-ACCEL, -MAX_SPEED*2) # Aceleração e Limitar Velocidade
		sprite.flip_h = true
	#	Movimento Direita
	elif Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x+ACCEL, MAX_SPEED*2) # Aceleração e Limitar Velocidade
		sprite.flip_h = false
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()
	set_state(check_rush_state())

func wall_slide(_delta):
	sprite.play("wall_slide")
	if enter_state:
		audio_manager.play_sfx(sfx_wallslide)
		enter_state = false
	if velocity.y >= 0:
		velocity.y = min(velocity.y+WALL_SLIDE_ACCEL, WALL_SLIDE_MAX_SPEED)
	else:
		velocity.y += GRAVITY*4
	if (sprite.flip_h == true) and (Input.is_action_just_pressed("ui_select")):
		velocity.x = MAX_SPEED*3
	elif (sprite.flip_h == false) and (Input.is_action_just_pressed("ui_select")):
		velocity.x = -MAX_SPEED*3
	_move_and_slide()
	_collision_handler()
	set_state(check_wallslide_state())

func doublejump_state(_delta):
	if enter_state:
		audio_manager.play_sfx(sfx_djump)
		sprite.play("d_jump")
		JUMP_HEIGHT = 250
		velocity.y = -JUMP_HEIGHT
		enter_state = false
	velocity.x = lerp(velocity.x, 0, 0.1)
	_gravity(_delta)
	if p_input:
		_move()
	_move_and_slide()
	_collision_handler()
	set_state(check_doublejump_state())

func crouchrun_state(_delta):
	sprite.play("crouch_run")
	if p_input:
		_move()
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()
	set_state(check_crouchrun_state())

func hurt_state(_delta):
	sprite.play("hurt")
	if enter_state:
		p_input = false
		audio_manager.play_sfx(sfx_hurt)
		JUMP_HEIGHT = 250
		if is_on_floor():
			if Global.hit_side == 1:
				velocity.x = MAX_SPEED*1.5
				if sprite.flip_h == false:
					sprite.flip_h = true
			elif Global.hit_side == -1:
				velocity.x = -MAX_SPEED*1.5
				if sprite.flip_h == true:
					sprite.flip_h = false
		enter_state = false
		can_hurt = false
		knockback_timer.start()
	
	_move_and_slide()
	velocity.x = lerp(velocity.x, 0, 0.5)
	velocity.y += GRAVITY/2
	blink()
	_collision_handler()
	set_state(check_hurt_state())

func dead_state(_delta):
	yield(get_tree().create_timer(.5), "timeout")
	if enter_state:
		p_input = false
		audio_manager.play_sfx(sfx_die)
		enter_state = false
	velocity.x = 0
	sprite.play("die")
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()

func exit_state(_delta):
	sprite.play("run")
	if exit_raycastR.is_colliding():
		exit_dir = 1
		exit_raycastL.enabled = false
	elif exit_raycastL.is_colliding():
		exit_dir = 0
		exit_raycastR.enabled = false
	else:
		exit_dir = null
	
	if exit_dir == 1:
		velocity.x = MAX_SPEED
		sprite.flip_h = false
	if exit_dir == 0:
		velocity.x = -MAX_SPEED
		sprite.flip_h = true
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()

func defense_state(_delta):
	velocity.x = 0
	if Global.upgrades.best_shield == true:
		sprite.play("bestshield")
	else:
		sprite.play("defense")
	
	_gravity(_delta)
	_collision_handler()
	_move_and_slide()
	set_state(check_defense_state())

func castcharge_state(_delta):
	particle_charge.visible = true
	particle_charge.emitting = true
	velocity.x = lerp(velocity.x, 0, 0.3)
	sprite.play("cast")
	
	_gravity(_delta)
	_collision_handler()
	_move_and_slide()
	if sprite.frame == 2:
		yield(get_tree().create_timer(.5), "timeout")
		set_state(check_castcharge_state())

func cast_state(_delta):
	velocity.x = lerp(velocity.x, 0, 0.3)
	sprite.play("cast_loop")
	if can_shot == true:
		instance_fireball()
		can_shot = false
		Global.mp -= 5
		emit_signal("cast")
	
	_gravity(_delta)
	_collision_handler()
	_move_and_slide()
	yield(get_tree().create_timer(.5), "timeout")
	set_state(check_cast_state())

#CHECK FUNCTIONS---------------------------------------------------------------------------------------------------------------------------------------------
func check_idle_state():
	var new_state = current_state
	if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and (!Input.is_action_pressed("ui_shift")):
		new_state = RUN
	elif Input.is_action_just_pressed("ui_action"):
		new_state = ATTACK
	elif Input.is_action_just_pressed("ui_select"):
		new_state = JUMP
	elif !is_on_floor():
		new_state = FALL
	elif Input.is_action_pressed("ui_down"):
		new_state = CROUCH
	elif (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and Input.is_action_pressed("ui_shift") and Global.upgrades.rush == true:
		new_state = RUSH
	elif hit == true:
		new_state = HURT
	elif exit == true:
		new_state = EXIT
	elif Input.is_action_pressed("ui_defense") and is_on_floor():
		new_state = DEFENSE
	elif Input.is_action_pressed("ui_magic") and is_on_floor() and Global.upgrades.fireball == true:
		new_state = CAST_CHARGE
	return new_state

func check_run_state():
	var new_state = current_state
	if (!Input.is_action_pressed("ui_left")) and (!Input.is_action_pressed("ui_right")):
		new_state = IDLE
	elif Input.is_action_just_pressed("ui_action"):
		new_state = ATTACK
	elif Input.is_action_just_pressed("ui_select"):
		new_state = JUMP
	elif !is_on_floor():
		new_state = FALL
	elif Input.is_action_pressed("ui_shift") and Global.upgrades.rush == true:
		new_state = RUSH
	elif Input.is_action_pressed("ui_down"):
		new_state = CROUCH_RUN
	elif hit == true:
		new_state = HURT
	elif exit == true:
		new_state = EXIT
	elif Input.is_action_pressed("ui_defense") and is_on_floor():
		new_state = DEFENSE
	elif Input.is_action_pressed("ui_magic") and is_on_floor() and Global.upgrades.fireball == true:
		new_state = CAST_CHARGE
	return new_state

func check_jump_state():
	var new_state = current_state
	var on_wall = raycast_wall1.is_colliding() and raycast_wall2.is_colliding() and raycast_wall3.is_colliding() and raycast_wall4.is_colliding() and raycast_wall5.is_colliding()
	if velocity.y >= 0:
		new_state = FALL
	elif Input.is_action_just_pressed("ui_action"):
		new_state = ATTACK
	elif on_wall and (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
		new_state = WALL_SLIDE
	elif !is_on_floor() and Input.is_action_just_pressed("ui_select") and Global.upgrades.double_jump == true:
		new_state = D_JUMP
	elif hit == true:
		new_state = HURT
	return new_state

func check_fall_state():
	var new_state = current_state
	var on_wall = raycast_wall1.is_colliding() and raycast_wall2.is_colliding() and raycast_wall3.is_colliding() and raycast_wall4.is_colliding() and raycast_wall5.is_colliding()
	if is_on_floor():
		new_state = IDLE
	elif Input.is_action_just_pressed("ui_action"):
		new_state = ATTACK
	elif on_wall and (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
		new_state = WALL_SLIDE
	elif !is_on_floor() and Input.is_action_just_pressed("ui_select") and Global.upgrades.double_jump == true:
		new_state = D_JUMP
	elif hit == true:
		new_state = HURT
	elif exit == true and is_on_floor():
		new_state = EXIT
	return new_state

func check_crouch_state():
	var new_state = current_state
	if !Input.is_action_pressed("ui_down"):
		new_state = IDLE
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		new_state = CROUCH_RUN
	elif Input.is_action_just_pressed("ui_action"):
		new_state = ATTACK
	elif !is_on_floor():
		new_state = FALL
	elif Input.is_action_just_pressed("ui_select") and Global.upgrades.slide == true:
		dash_timer.start()
		new_state = SLIDE
	elif hit == true:
		new_state = HURT
	elif exit == true:
		new_state = EXIT
	return new_state

func check_slide_state():
	var new_state = current_state
	if !is_on_floor():
		new_state = FALL
	elif dash_timer.is_stopped() and (!Input.is_action_pressed("ui_down")):
		new_state = IDLE
	elif dash_timer.is_stopped() and Input.is_action_pressed("ui_down"):
		new_state = CROUCH
	elif hit == true:
		new_state = HURT
	elif exit == true:
		new_state = EXIT
	return new_state

func check_rush_state():
	var new_state = current_state
	if (!Input.is_action_pressed("ui_left")) and (!Input.is_action_pressed("ui_right")):
		new_state = IDLE
	elif Input.is_action_just_pressed("ui_action"):
		new_state = ATTACK
	elif Input.is_action_just_pressed("ui_select"):
		new_state = JUMP
	elif !is_on_floor():
		new_state = FALL
	elif Input.is_action_just_released("ui_shift"):
		new_state = RUN
	elif Input.is_action_pressed("ui_down"):
		new_state = CROUCH_RUN
	elif hit == true:
		new_state = HURT
	elif exit == true:
		new_state = EXIT
	elif Input.is_action_pressed("ui_defense") and is_on_floor():
		new_state = DEFENSE
	elif Input.is_action_pressed("ui_magic") and is_on_floor() and Global.upgrades.fireball == true:
		new_state = CAST_CHARGE
	return new_state

func check_wallslide_state():
	var new_state = current_state
	var on_wall = raycast_wall1.is_colliding() and raycast_wall2.is_colliding() and raycast_wall3.is_colliding() and raycast_wall4.is_colliding() and raycast_wall5.is_colliding()
	if is_on_floor():
		audio_manager.stop_sfx(sfx_wallslide)
		new_state = IDLE
	elif on_wall and (!Input.is_action_pressed("ui_left")) and (!Input.is_action_pressed("ui_right")):
		audio_manager.stop_sfx(sfx_wallslide)
		new_state = FALL
	elif on_wall and Input.is_action_just_pressed("ui_select"):
		audio_manager.stop_sfx(sfx_wallslide)
		JUMP_HEIGHT = JUMP_HEIGHT*1.2
		new_state = JUMP
	elif !on_wall and velocity.y != 0:
		audio_manager.stop_sfx(sfx_wallslide)
		new_state = FALL
	elif hit == true:
		audio_manager.stop_sfx(sfx_wallslide)
		new_state = HURT
	elif exit == true:
		audio_manager.stop_sfx(sfx_wallslide)
		new_state = EXIT
	return new_state

func check_doublejump_state():
	var new_state = current_state
	var on_wall = raycast_wall1.is_colliding() and raycast_wall2.is_colliding() and raycast_wall3.is_colliding() and raycast_wall4.is_colliding() and raycast_wall5.is_colliding()
	if is_on_floor():
		new_state = IDLE
	elif Input.is_action_just_pressed("ui_action"):
		new_state = ATTACK
	elif on_wall and (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
		new_state = WALL_SLIDE
	elif hit == true:
		new_state = HURT
	elif exit == true:
		new_state = EXIT
	return new_state

func check_crouchrun_state():
	var new_state = current_state
	if (!Input.is_action_pressed("ui_left")) and (!Input.is_action_pressed("ui_right")) and (Input.is_action_pressed("ui_down")):
		new_state = CROUCH
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right") and (!Input.is_action_pressed("ui_down")):
		new_state = RUN
	elif Input.is_action_just_pressed("ui_action"):
		new_state = ATTACK
	elif !is_on_floor():
		new_state = FALL
	elif !Input.is_action_pressed("ui_down"):
		new_state = IDLE
	elif hit == true:
		new_state = HURT
	elif exit == true:
		new_state = EXIT
	return new_state

func check_hurt_state():
	var new_state = current_state
	if Global.hp <= 0:
		new_state = DEAD
	elif exit == true:
		new_state = EXIT
	return new_state

func check_defense_state():
	var new_state = current_state
	if !Input.is_action_pressed("ui_defense"):
		new_state = IDLE
	elif !is_on_floor():
		new_state = FALL
	elif exit == true:
		new_state = EXIT
	return new_state

func check_castcharge_state():
	var new_state = current_state
	
	if !Input.is_action_pressed("ui_magic"):
		if Global.mp >= 5:
			particle_charge.visible = false
			particle_charge.emitting = false
			new_state = CAST
		else:
			particle_charge.visible = false
			particle_charge.emitting = false
			new_state = IDLE
	elif !is_on_floor():
		new_state = FALL
	elif exit == true:
		new_state = EXIT
	elif hit == true:
		new_state = HURT
	return new_state

func check_cast_state():
	var new_state = current_state
	if is_on_floor():
		can_shot = true
		new_state = IDLE
	elif !is_on_floor():
		can_shot = true
		new_state = FALL
	elif exit == true:
		can_shot = true
		new_state = EXIT
	elif hit == true:
		can_shot = true
		new_state = HURT
	return new_state

#HELPERS---------------------------------------------------------------------------------------------------------------------------------------------
func _gravity(_delta):
	velocity.y += GRAVITY
	
func _move_and_slide():
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _move():
	#	Movimento Esquerda
	if Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x-ACCEL, -MAX_SPEED) # Aceleração e Limitar Velocidade
		sprite.flip_h = true
		raycast_wall1.rotation_degrees = 90
		raycast_wall2.rotation_degrees = 90
		raycast_wall3.rotation_degrees = 90
		raycast_wall4.rotation_degrees = 90
		raycast_wall5.rotation_degrees = 90
		hitbox_attack.position.x = -12.5
		partner.position.x = 15
		partner.position.y = -1
	#	Movimento Direita
	elif Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x+ACCEL, MAX_SPEED) # Aceleração e Limitar Velocidade
		sprite.flip_h = false
		raycast_wall1.rotation_degrees = -90
		raycast_wall2.rotation_degrees = -90
		raycast_wall3.rotation_degrees = -90
		raycast_wall4.rotation_degrees = -90
		raycast_wall5.rotation_degrees = -90
		hitbox_attack.position.x = 12.5
		partner.position.x = -15
		partner.position.y = -1
	else: pass

func set_state(new_state):
	if new_state != current_state:
		enter_state = true
	current_state = new_state

func _collision_handler():
	var anim_frame = sprite.frame
	var anim = sprite.animation
	
	if current_state == SLIDE:
		col_slide.disabled = false
		col_stand.disabled = true
		col_crouch.disabled = true
	elif current_state == CROUCH || current_state == CROUCH_RUN || current_state == D_JUMP:
		col_slide.disabled = true
		col_stand.disabled = true
		col_crouch.disabled = false
	else:
		col_slide.disabled = true
		col_stand.disabled = false
		col_crouch.disabled = true
		col_crouch.position.y = 21.5
		
	if current_state == DEAD:
		hurtbox.disabled = true
	else:
		hurtbox.disabled = false
	
	if (anim == "attack1" and anim_frame == 2):
		hitbox_attack.disabled = false
	elif (anim == "attack2" and anim_frame == 3):
		hitbox_attack.disabled = false
	elif (anim == "attack3" and anim_frame == 2):
		hitbox_attack.disabled = false
	elif (anim == "attack_air1" and anim_frame == 1):
		hitbox_attack.disabled = false
	elif (anim == "attack_air2" and anim_frame == 0):
		hitbox_attack.disabled = false
	elif (anim == "attack_air3"):
		hitbox_attack.disabled = false
	else:
		hitbox_attack.disabled = true

func force_idle():
	sprite.play("idle")
	set_state(IDLE)

func instance_hit():
	var hit_spr = hit_fx.instance()
	self.add_child(hit_spr)
	hit_spr.global_position.y = self.position.y+18
	if sprite.flip_h == false:
		hit_spr.global_position.x = self.position.x+10
	else:
		hit_spr.global_position.x = self.position.x-10

func instance_fireball():
	var f_ball = fireball.instance()
	self.add_child(f_ball)
	f_ball.global_position.y = self.position.y+16
	if sprite.flip_h == false:
		f_ball.global_position.x = self.position.x+25
		f_ball.velocity = f_ball.velocity * 1
		f_ball.scale.x = 1
	else:
		f_ball.global_position.x = self.position.x-25
		f_ball.velocity = f_ball.velocity * -1
		f_ball.scale.x = -1

func get_item(area):
	if area.name == "item_LifeUP_area":
		audio_manager.play_sfx(sfx_collect)
		Global.max_hp += 50
		area.get_parent().queue_free()
	if area.name == "item_ManaUp_area":
		audio_manager.play_sfx(sfx_collect)
		Global.max_mp += 10
		area.get_parent().queue_free()
	if area.name == "item_BestShield_area":
		audio_manager.play_sfx(sfx_collect)
		Global.upgrades.best_shield = true
		area.get_parent().queue_free()
	if area.name == "item_RedSword_area":
		audio_manager.play_sfx(sfx_collect)
		Global.upgrades.red_sword = true
		area.get_parent().queue_free()
	if area.name == "item_SlideBoots_area":
		audio_manager.play_sfx(sfx_collect)
		Global.upgrades.slide = true
		area.get_parent().queue_free()
	if area.name == "item_DoubleBoots_area":
		audio_manager.play_sfx(sfx_collect)
		Global.upgrades.double_jump = true
		area.get_parent().queue_free()
	if area.name == "item_FlameGauntlet_area":
		audio_manager.play_sfx(sfx_collect)
		Global.upgrades.fireball = true
		area.get_parent().queue_free()
	if area.name == "item_SpeedScarf_area":
		audio_manager.play_sfx(sfx_collect)
		Global.upgrades.rush = true
		area.get_parent().queue_free()
	if area.name == "liferecover_area":
		audio_manager.play_sfx(sfx_collect)
	if area.name == "coin_area":
		audio_manager.play_sfx(sfx_collect)

func change_color():
	if Global.upgrades.rush == true:
		sprite.material.set("shader_param/NEW_COLOR1", Color(0.290196, 0.901961, 0.768627, 1))
		sprite.material.set("shader_param/NEW_COLOR2", Color(0.219608, 0.709804, 0.65098, 1))
		sprite.material.set("shader_param/NEW_COLOR3", Color(0.156863, 0.596078, 0.541176, 1))
	elif Global.upgrades.rush == false:
		sprite.material.set("shader_param/NEW_COLOR1", Color(0.85098, 0.341176, 0.388235, 1))
		sprite.material.set("shader_param/NEW_COLOR2", Color(0.670588, 0.262745, 0.262745, 1))
		sprite.material.set("shader_param/NEW_COLOR3", Color(0.560784, 0.196078, 0.196078, 1))
	
	if Global.upgrades.red_sword == true:
		sprite.material.set("shader_param/NEW_COLOR4", Color(1, 0.686275, 0.752941, 1))
		sprite.material.set("shader_param/NEW_COLOR5", Color(0.996078, 0.337255, 0.478431, 1))
		sprite.material.set("shader_param/NEW_COLOR6", Color(0.623529, 0, 0.278431, 1))
		sprite.material.set("shader_param/NEW_COLOR7", Color(0.796078, 0.858824, 0.988235, 1))
		sprite.material.set("shader_param/NEW_COLOR8", Color(0.552941, 0.584314, 0.839216, 1))
		sprite.material.set("shader_param/NEW_COLOR9", Color(0.517647, 0.494118, 0.529412, 1))
		sprite.material.set("shader_param/NEW_COLOR10", Color(0.317647, 0.305882, 0.34902, 1))
	elif Global.upgrades.red_sword == false:
		sprite.material.set("shader_param/NEW_COLOR4", Color(0.760784, 0.784314, 0.941176, 1))
		sprite.material.set("shader_param/NEW_COLOR5", Color(0.647059, 0.682353, 0.917647, 1))
		sprite.material.set("shader_param/NEW_COLOR6", Color(0.521569, 0.564706, 0.623529, 1))
		sprite.material.set("shader_param/NEW_COLOR7", Color(0.921569, 0.776471, 0.34902, 1))
		sprite.material.set("shader_param/NEW_COLOR8", Color(0.701961, 0.6, 0.196078, 1))
		sprite.material.set("shader_param/NEW_COLOR9", Color(0.411765, 0.356863, 0.152941, 1))
		sprite.material.set("shader_param/NEW_COLOR10", Color(0.321569, 0.25098, 0.117647, 1))

#COLIDIR COM A HURTBOX---------------------------------------------------------------------------------------------------------------------------------------------------
func _on_hurtbox_area_entered(area):
	
	if area.is_in_group("Scene_change") and (exit_raycastR.is_colliding() or exit_raycastL.is_colliding()):
		$hurtbox/scene_change_timer.start()
		exit = true
	
	if area.is_in_group("E_Hitbox") and (can_hurt == true) and (current_state != DEAD) and (current_state != DEFENSE):
		instance_hit()
		Global.camera.shake(150, 0.4, 100)
		Global.frame_freeze(0.1, 0.4)
		hit = true
		emit_signal("damaged")
	
	if area.is_in_group("E_Hitbox") and (current_state == DEFENSE):
		instance_hit()
		audio_manager.play_sfx(sfx_guard)
		Global.camera.shake(150, 0.4, 100)
		emit_signal("damaged")
	
	get_item(area)

#COLIDIR COM A HITBOX---------------------------------------------------------------------------------------------------------------------------------------------------
func _on_Hitbox_area_entered(area):
	if area.is_in_group("E_Hurtbox") and area.get_parent().current_state != area.get_parent().DEAD:
		audio_manager.play_sfx(sfx_damage)
#		Global.frame_freeze(0.1, 0.4)
		if (hitbox_attack.position.x == -12.5):
			Global.e_hit_side = -1
		elif (hitbox_attack.position.x == 12.5):
			Global.e_hit_side = 1
#PISCAR---------------------------------------------------------------------------------------------------------------------------------------------------
func blink():
	for i in 15:
		sprite.modulate.a = 0.5
		yield(get_tree().create_timer(0.1), "timeout")
		sprite.modulate.a = 1
		yield(get_tree().create_timer(0.1), "timeout")
	
#TIRAR CONTROLES AO MUDAR DE CENA---------------------------------------------------------------------------------------------------------------------------------------------------
func _on_scene_change_timer_timeout():
	p_input = false
#ANIMAÇÃO TERMINAR---------------------------------------------------------------------------------------------------------------------------------------------------
func _on_sprite_animation_finished():
	var anim = sprite.animation
	
	#ATTACK ANIMATION FINISHED
	if anim == "attack1":
		attack_points = attack_points - 1
		attack = false
		set_state(IDLE)
	if anim == "attack2":
		attack_points = attack_points - 1
		attack = false
		set_state(IDLE)
	if anim == "attack3":
		attack_points = attack_points - 1
		attack = false
		attack_points = 3
		set_state(IDLE)
	if anim == "attack_air1":
		attack_points = attack_points - 1
		attack = false
		set_state(FALL)
	if anim == "attack_air2":
		attack_points = attack_points - 1
		attack = false
		set_state(FALL)
	if anim == "attack_air3":
		attack_points = attack_points - 1
		attack = false
		attack_points = 3
		set_state(FALL)
	#HURT ANIMATION FINISHED
	if anim == "hurt":
		hit = false
		p_input = true
		set_state(IDLE)
	#DEAD ANIMATION FINISHED
	if anim == "die":
		dead = true

#TIMER DA GHOST TRAIL TERMINAR---------------------------------------------------------------------------------------------------------------------------------------------------
func _on_ghost_timer_timeout():
	if current_state == RUSH or current_state == SLIDE or current_state == D_JUMP or sprite.animation == "attack_air3":
		var ghost = preload("res://Prefabs/Ghost_trail.tscn").instance()
		get_parent().get_parent().add_child(ghost)
		ghost.position.x = position.x
		ghost.position.y = position.y + 14
		ghost.texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
		ghost.flip_h = sprite.flip_h
#TIMER PARA RESETAR OS ATTACK_POINTS---------------------------------------------------------------------------------------------------------------------------------------------------
func _on_attackreset_timer_timeout():
	attack_points = 3
#TIMER PARA TERMINAR A INVENCIBILIDADE
func _on_knockback_timer_timeout():
	can_hurt = true
	if dead == true:
		get_parent().failed()
#MP RECOVERY TIMER TERMINAR
func _on_mp_timer_timeout():
	if Global.mp < Global.max_mp:
		Global.mp += 1

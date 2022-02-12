extends KinematicBody2D
var GRAVITY = 10
var MAX_SPEED = 50
var ACCEL = 25
var velocity = Vector2.ZERO

var current_state := 2
enum { IDLE, ATTACK, RUN, FALL, HURT, DEAD }
var enter_state := true

var hp = 20
var hp_max = 20
var attack_points = 1
var attack = false
var hit = false
var can_hurt = true
var stop = false
var Name = "Slime"
var RNG = RandomNumberGenerator.new()
var item = 0

export var atk_value = 10
onready var sprite = $sprite
onready var raycast_run1 = $raycast_run1
onready var raycast_run2 = $raycast_run2
onready var raycast_attack = $raycast_attack
onready var raycast_wall = $raycast_wall
onready var attack_hitbox = $hitbox/attack_hitbox
onready var attack_timer = $attackreset_timer
onready var knockback_timer = $knockback_timer
onready var movestop_timer = $movestop_timer
onready var tween = $alpha_tween
onready var audio_manager = $audio_manager
onready var enemy_hud = $Enemy_HUD
onready var e_hpbar = $Enemy_HUD/e_life
onready var hpbar_timer = $Enemy_HUD/timer
#INSTANCE VARIABLES
onready var hit_fx = preload("res://Prefabs/fx_hit.tscn")
onready var life_recover = preload("res://Prefabs/Life_Recover.tscn")
onready var coin = preload("res://Prefabs/Coin.tscn")
#SOUND_FX VARIABLES
var sfx_hurt : AudioStream = load("res://Sounds/SFX/konstati - Slime hurt.wav")
var sfx_attack : AudioStream = load("res://Sounds/SFX/konstati - Slime attack.wav")
var sfx_die : AudioStream = load("res://Sounds/SFX/qubodup - Slime Squish.wav")
var sfx_pursuit : AudioStream = load("res://Sounds/SFX/konstati - Slime pursuit.wav")
var sfx_damage : AudioStream = load("res://Sounds/SFX/raclure - Damage SFX.wav")

signal e_damaged
#PROCESSO AO INICIAR---------------------------------------------------------------------------------------------------------------------------------------------
func _ready():
	RNG.randomize()
	pass
#STATES---------------------------------------------------------------------------------------------------------------------------------------------
func _physics_process(delta):
	
	match current_state:
		IDLE:
			idle_state(delta)
		ATTACK:
			attack_state(delta)
		RUN:
			run_state(delta)
		FALL:
			fall_state(delta)
		HURT:
			hurt_state(delta)
		DEAD:
			dead_state(delta)
	
	set_hpbar()
	
#STATES---------------------------------------------------------------------------------------------------------------------------------------------
func idle_state(_delta):
	velocity.x = 0
	sprite.play("idle")
	_gravity(_delta)
	_collision_handler()
	set_state(check_idle_state())

func attack_state(_delta):
	velocity.x = 0
	
	if attack_points == 1:
			attack_timer.start()
			if attack == false:
				audio_manager.play_sfx(sfx_attack)
				sprite.play("attack")
				attack = true
	if hit == true:
		attack = false
		attack_points = 1
		set_state(HURT)
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()

func run_state(_delta):
	sprite.play("run")
	if enter_state:
		audio_manager.play_sfx(sfx_pursuit)
		enter_state = false
	if !raycast_run1.is_colliding() and !raycast_run2.is_colliding():
		raycast_run1.enabled = false
		raycast_run1.enabled = false
		stop = true
		movestop_timer.start()
	_move()
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()
	set_state(check_run_state())

func fall_state(_delta):
	velocity.x = lerp(velocity.x, 0, 0.3)
	sprite.play("fall")
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()
	set_state(check_fall_state())

func hurt_state(_delta):
	sprite.play("hurt")
	if enter_state:
		audio_manager.play_sfx(sfx_hurt)
		if Global.e_hit_side == 1:
			velocity.x = MAX_SPEED*1.5
			if sprite.flip_h == true:
				sprite.flip_h = false
		elif Global.e_hit_side == -1:
			velocity.x = -MAX_SPEED*1.5
			if sprite.flip_h == false:
				sprite.flip_h = true
		enter_state = false
		can_hurt = false
		knockback_timer.start()
	_move_and_slide()
	velocity.x = lerp(velocity.x, 0, 0.03)
	_collision_handler()
	set_state(check_hurt_state())

func dead_state(_delta):
	velocity.x = 0
	if enter_state:
		audio_manager.play_sfx(sfx_die)
		item_drop()
		enter_state = false
	sprite.play("die")
	_gravity(_delta)
	_move_and_slide()
	_collision_handler()
	yield(get_tree().create_timer(2.0), "timeout")
	tween.interpolate_property(self, "modulate", Color( 1, 1, 1, 1), Color( 0, 0, 0, 0), .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()


#CHECK FUNCTIONS---------------------------------------------------------------------------------------------------------------------------------------------
func check_idle_state():
	var new_state = current_state
	if (raycast_run1.is_colliding() or raycast_run2.is_colliding()) and stop == false:
		new_state = RUN
	elif !is_on_floor():
		new_state = FALL
	elif raycast_attack.is_colliding():
		new_state = ATTACK
	elif hit == true:
		new_state = HURT
	return new_state

func check_run_state():
	var new_state = current_state
	if !is_on_floor():
		new_state = FALL
	elif raycast_wall.is_colliding():
		new_state = IDLE
	elif raycast_attack.is_colliding():
		new_state = ATTACK
	elif hit == true:
		new_state = HURT
	elif stop == true:
		new_state = IDLE
	return new_state

func check_fall_state():
	var new_state = current_state
	if is_on_floor():
		new_state = IDLE
	elif hit == true:
		new_state = HURT
	return new_state

func check_hurt_state():
	var new_state = current_state
	if hp <= 0:
		new_state = DEAD
	return new_state

#HELPERS---------------------------------------------------------------------------------------------------------------------------------------------
func _gravity(_delta):
	velocity.y += GRAVITY

func _move_and_slide():
	velocity = move_and_slide(velocity, Vector2.UP)

func _move():
	
	if raycast_run1.is_colliding():
		velocity.x = -MAX_SPEED
		sprite.flip_h = false
		raycast_wall.rotation_degrees = 90
		raycast_attack.rotation_degrees = 90
		attack_hitbox.position.x = -14

	elif raycast_run2.is_colliding():
		velocity.x = MAX_SPEED
		sprite.flip_h = true
		raycast_wall.rotation_degrees = -90
		raycast_attack.rotation_degrees = -90
		attack_hitbox.position.x = 16

func set_state(new_state):
	if new_state != current_state:
		enter_state = true
	current_state = new_state

func _collision_handler():
	var anim_frame = sprite.frame
	var anim = sprite.animation
	
	if raycast_run1.is_colliding():
		raycast_run2.enabled = false
	else:
		raycast_run2.enabled = true
	
	if raycast_run2.is_colliding():
		raycast_run1.enabled = false
	else:
		raycast_run1.enabled = true
	
	if attack_points != 1:
		raycast_run1.enabled = false
		raycast_run2.enabled = false
		raycast_attack.enabled = false
	else:
		raycast_attack.enabled = true
		
	
	if (anim == "attack" and anim_frame == 2):
		attack_hitbox.disabled = false
	else:
		attack_hitbox.disabled = true

func blink():
	for i in 10:
		sprite.modulate.a = 0.5
		yield(get_tree().create_timer(0.1), "timeout")
		sprite.modulate.a = 1
		yield(get_tree().create_timer(0.1), "timeout")

func instance_hit():
	var hit_spr = hit_fx.instance()
	self.add_child(hit_spr)
	hit_spr.global_position.y = self.position.y-8
	if sprite.flip_h == false:
		hit_spr.global_position.x = self.position.x-12
	else:
		hit_spr.global_position.x = self.position.x+12

func item_drop():
	var instance_item
	item = RNG.randi_range(1, 4)
	if item == 1:
		instance_item = life_recover.instance()
		get_parent().add_child(instance_item)
		instance_item.global_position.x = global_position.x
		instance_item.global_position.y = global_position.y - 24.5
	elif item == 2:
		instance_item = coin.instance()
		get_parent().add_child(instance_item)
		instance_item.global_position.x = global_position.x
		instance_item.global_position.y = global_position.y - 24.5
	elif item == 3:
		if Global.hp <= Global.max_hp/2:
			instance_item = life_recover.instance()
			get_parent().add_child(instance_item)
			instance_item.global_position.x = global_position.x
			instance_item.global_position.y = global_position.y - 24.5
		else: pass
	elif item == 4:
		if Global.hp <= Global.max_hp/2:
			instance_item = life_recover.instance()
			get_parent().add_child(instance_item)
			instance_item.global_position.x = global_position.x
			instance_item.global_position.y = global_position.y - 24.5
		else: pass

func _on_sprite_animation_finished():
	var anim = sprite.animation
	
	#ATTACK ANIMATION FINISHED
	if anim == "attack":
		attack_points = attack_points - 1
		attack = false
		set_state(IDLE)
	#HURT ANIMATION FINISHED
	if anim == "hurt":
		hit = false
		set_state(IDLE)

func _on_attackreset_timer_timeout():
	attack_points = 1

func _on_hitbox_area_entered(area):
	if area.is_in_group("P_Hurtbox"):
		if area.get_parent().can_hurt == true:
			audio_manager.play_sfx(sfx_damage)
		
		if area.get_parent().current_state == area.get_parent().DEFENSE:
#			atk_value = 1.5
			atk_value = 3
		if Global.upgrades.best_shield == false:
			Global.hp -= atk_value
		elif area.get_parent().current_state != area.get_parent().DEFENSE:
			atk_value = 10
			Global.hp -= atk_value
		
		if (attack_hitbox.position.x == -14):
			Global.hit_side = -1
		elif (attack_hitbox.position.x == 16):
			Global.hit_side = 1

func _on_hurtbox_area_entered(area):
	if area.is_in_group("P_Hitbox") and (can_hurt == true) and (current_state != DEAD):
		hp -= Global.player_atk
		instance_hit()
		Global.camera.shake(50, 0.4, 100)
		blink()
		hit = true
		Global.current_enemy = 0
		enemy_hud.visible = true
		hpbar_timer.start()
		emit_signal("e_damaged")
	
	if area.is_in_group("P_projectile") and (can_hurt == true) and (current_state != DEAD):
		hp -= Global.player_atk*2
		Global.camera.shake(50, 0.4, 100)
		audio_manager.play_sfx(sfx_damage)
		blink()
		hit = true
		Global.current_enemy = 0
		enemy_hud.visible = true
		hpbar_timer.start()
		emit_signal("e_damaged")

func _on_knockback_timer_timeout():
	can_hurt = true

func _on_movestop_timer_timeout():
	raycast_run1.enabled = true
	raycast_run2.enabled = true
	stop = false

func _on_alpha_tween_tween_completed(object, key):
	queue_free()

func set_hpbar():
	e_hpbar.value = hp
	e_hpbar.max_value = hp_max

func _on_timer_timeout():
	enemy_hud.visible = false

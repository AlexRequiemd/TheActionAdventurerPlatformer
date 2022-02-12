extends KinematicBody2D
export(float, 1, 1000) var frequency = 5
export(float, 1000) var amplitude = 100
var time = 0
var GRAVITY = 0
var MAX_SPEED = 1
var ACCEL = 25
var velocity = Vector2.ZERO

var current_state := 0
enum {RUN, HURT, DEAD }
var enter_state := true

var hp = 10
var hp_max = 10
var attack_points = 1
var attack = false
var hit = false
var can_hurt = true
var stop = false
var Name = "Flying_Eye"
var RNG = RandomNumberGenerator.new()
var item = 0

export var atk_value = 10
export var flip = true

onready var postion2d = $Position2D
onready var sprite = $sprite
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
var sfx_hurt : AudioStream = load("res://Sounds/SFX/vox_artist - Monster Dying2.wav")
var sfx_die : AudioStream = load("res://Sounds/SFX/vox_artist - Monster Dying.wav")
var sfx_damage : AudioStream = load("res://Sounds/SFX/raclure - Damage SFX.wav")

signal e_damaged
#PROCESSO AO INICIAR---------------------------------------------------------------------------------------------------------------------------------------------
func _ready():
	RNG.randomize()
	pass
#STATES---------------------------------------------------------------------------------------------------------------------------------------------
func _physics_process(delta):
	
	match current_state:
		RUN:
			run_state(delta)
		HURT:
			hurt_state(delta)
		DEAD:
			dead_state(delta)
	
	set_hpbar()
	
#STATES---------------------------------------------------------------------------------------------------------------------------------------------
func run_state(_delta):
	sprite.play("run")
	_direction()
	_move(_delta)
	_move_and_slide()
	_collision_handler()
	set_state(check_run_state())

func hurt_state(_delta):
	sprite.play("hurt")
	if enter_state:
		audio_manager.play_sfx(sfx_hurt)
		if Global.e_hit_side == 1:
			velocity.x = MAX_SPEED*1.5
			if sprite.flip_h == false:
				sprite.flip_h = true
		elif Global.e_hit_side == -1:
			velocity.x = -MAX_SPEED*1.5
			if sprite.flip_h == true:
				sprite.flip_h = false
		enter_state = false
		can_hurt = false
		knockback_timer.start()
	_direction()
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
	_direction()
	_move_and_slide()
	_collision_handler()
	yield(get_tree().create_timer(2.0), "timeout")
	tween.interpolate_property(self, "modulate", Color( 1, 1, 1, 1), Color( 0, 0, 0, 0), .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

#CHECK FUNCTIONS---------------------------------------------------------------------------------------------------------------------------------------------
func check_run_state():
	var new_state = current_state
	if hit == true:
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

func _move(_delta):
	time += _delta
	var movement = cos(time*frequency)*amplitude
	
	if flip == true:
		position.y += movement*_delta
		position.x -= MAX_SPEED

	elif flip == false:
		position.y += movement*_delta
		position.x += MAX_SPEED

func set_state(new_state):
	if new_state != current_state:
		enter_state = true
	current_state = new_state

func _collision_handler():
	if attack_points != 1:
		if hit == true:
			attack_hitbox.disabled = true
		else:
			attack_hitbox.disabled = true
	else:
		if hit == true:
			attack_hitbox.disabled = true
		else:
			attack_hitbox.disabled = false

func blink():
	for i in 10:
		sprite.modulate.a = 0.5
		yield(get_tree().create_timer(0.1), "timeout")
		sprite.modulate.a = 1
		yield(get_tree().create_timer(0.1), "timeout")

func instance_hit():
	var hit_spr = hit_fx.instance()
	self.add_child(hit_spr)
	hit_spr.global_position.y = self.position.y-33
	if sprite.flip_h == false:
		hit_spr.global_position.x = self.position.x+10
	else:
		hit_spr.global_position.x = self.position.x-10

func _direction():
	if flip == true:
		sprite.flip_h = true
	elif flip == false:
		sprite.flip_h = false

func _attack():
	if attack_points == 1:
			attack_timer.start()
			if attack == false:
				attack = true
				attack_points -= 1

func set_hpbar():
	e_hpbar.value = hp
	e_hpbar.max_value = hp_max

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
	#HURT ANIMATION FINISHED
	if anim == "hurt":
		hit = false
		set_state(RUN)

func _on_attackreset_timer_timeout():
	attack_points = 1
	attack = false

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
			_attack()
			_collision_handler()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("P_Hitbox") and (can_hurt == true) and (current_state != DEAD):
		instance_hit()
		hp -= Global.player_atk
		Global.camera.shake(50, 0.4, 100)
		blink()
		hit = true
		Global.current_enemy = 2
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
	stop = false

func _on_alpha_tween_tween_completed(object, key):
	queue_free()

func _on_timer_timeout():
	enemy_hud.visible = false

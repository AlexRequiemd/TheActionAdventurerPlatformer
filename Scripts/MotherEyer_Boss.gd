extends KinematicBody2D
#STATE VARIABLES
var current_state := 0
enum { IDLE, HURT, DEAD }
var enter_state := true
#OTHER VARIABLES
var hp = 800
var hp_max = 800
var hit = false
var can_hurt = true
var Name = "Mother Eye"
#ONREADY VARIABLES
onready var sprite = $sprite
onready var knockback_timer = $knockback_timer
onready var movestop_timer = $movestop_timer
onready var audio_manager = $audio_manager
onready var explosion = $Explosion_Boss/Particles2D
#INSTANCE VARIABLES
onready var hit_fx = preload("res://Prefabs/fx_hit.tscn")
#SOUND_FX VARIABLES
var sfx_damage : AudioStream = load("res://Sounds/SFX/raclure - Damage SFX.wav")
var sfx_explosion : AudioStream = load("res://Sounds/SFX/SOTN - Gaibon dies.wav")
#SIGNALS
signal boss_damaged

#PROCESSO AO INICIAR---------------------------------------------------------------------------------------------------------------------------------------------
func _ready():
	pass

#STATES---------------------------------------------------------------------------------------------------------------------------------------------
func _physics_process(delta):
	
	match current_state:
		IDLE:
			idle_state(delta)
		HURT:
			hurt_state(delta)
		DEAD:
			dead_state(delta)

#STATES---------------------------------------------------------------------------------------------------------------------------------------------
func idle_state(_delta):
	if hp > 400:
		sprite.play("idle")
	else:
		sprite.play("p2_idle")
	set_state(check_idle_state())

func hurt_state(_delta):
	if hp > 400:
		sprite.play("hurt")
	else:
		sprite.play("p2_hurt")
	if enter_state:
		enter_state = false
		can_hurt = false
		knockback_timer.start()
	set_state(check_hurt_state())

func dead_state(_delta):
	if enter_state:
		get_parent().dead = true
		audio_manager.play_sfx(sfx_explosion)
		explosion.emitting = true
		enter_state = false
	sprite.play("die")
	_disconnect()

#CHECK FUNCTIONS---------------------------------------------------------------------------------------------------------------------------------------------
func check_idle_state():
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
func set_state(new_state):
	if new_state != current_state:
		enter_state = true
	current_state = new_state

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

func _on_sprite_animation_finished():
	var anim = sprite.animation
	#HURT ANIMATION FINISHED
	if anim == "hurt":
		hit = false
		set_state(IDLE)
	if anim == "p2_hurt":
		hit = false
		set_state(IDLE)

func _on_hurtbox_area_entered(area):
	if area.is_in_group("P_Hitbox") and (can_hurt == true) and (current_state != DEAD):
		hp -= Global.player_atk
		instance_hit()
		Global.camera.shake(50, 0.4, 100)
		blink()
		hit = true
		emit_signal("boss_damaged")
	
	if area.is_in_group("P_projectile") and (can_hurt == true) and (current_state != DEAD):
		hp -= Global.player_atk*2
		Global.camera.shake(50, 0.4, 100)
		audio_manager.play_sfx(sfx_damage)
		blink()
		hit = true
		emit_signal("boss_damaged")

func _on_knockback_timer_timeout():
	can_hurt = true

func _disconnect():
	$Boss_HUD._disconnect()

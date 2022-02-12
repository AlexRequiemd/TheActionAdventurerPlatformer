extends Node
var boss_music : AudioStream = load("res://Sounds/BGM/LeviathanMusic - RPG 5.wav")
var failed_music : AudioStream = load("res://Sounds/BGM/Narutimate_Accel_2 - Wish... Dance on the Clouds_short.wav")
onready var lasereye_inst = load("res://Character/LaserEye_Boss.tscn")
onready var groundeye_inst = load("res://Character/GroundEye_group.tscn")
var lasereye = null
var lasereye_active = false
var groundeye = null
var groundeye_active = false
onready var audio_manager = $audio_manager
onready var hit_fx = preload("res://Prefabs/fx_hit.tscn")
onready var player = $Player
onready var anim_player = $Spike_group/anim_player
onready var attack_timer = $attack_timer
onready var HUD = $HUD
onready var fade_white = $Fade_In_White/ColorRect/anim_fade
onready var fade_black = $Fade_In_Black/ColorRect/anim_fade_black
onready var bg_spr = $Bg_spr
var cell_id
var hit = 0
var RNG = RandomNumberGenerator.new()
var current_attack = 0
var dead = false
var rand = true
var _atk = true
var can_attack = true
var fade = true
#------------------------------------------------------------------------------------------------------------------------------------------------
func _ready():
	audio_manager.play_music(boss_music)
	pass
#------------------------------------------------------------------------------------------------------------------------------------------------
func _process(delta):
	Global.current_cell = cell_id
	random()
	if dead == false:
		HUD.make_invisible_minimap()
		if can_attack == true:
			yield(get_tree().create_timer(1), "timeout")
			set_attack()
	if dead == true:
		audio_manager.stop_music(boss_music)
		if $Player.is_on_floor():
			$Player.force_idle()
			Global.dialogue_happen = true
		yield(get_tree().create_timer(3), "timeout")
		if fade == true:
			emit_signal("force_idle")
			fade_white.play("fade-in")
			fade = false

#------------------------------------------------------------------------------------------------------------------------------------------------
func random():
	if rand == true:
		RNG.randomize()
		current_attack = RNG.randi_range(1, 3)
		rand = false
#------------------------------------------------------------------------------------------------------------------------------------------------
func set_attack():
	if _atk == true:
		if current_attack == 1:
			attack_spike()
			current_attack = 0
		elif current_attack == 2:
			attack_lasereye()
			current_attack = 0
		elif current_attack == 3:
			attack_groundeye()
			current_attack = 0
	else:
		pass
#------------------------------------------------------------------------------------------------------------------------------------------------
func failed():
	$UI.failed()
	audio_manager.play_music(failed_music)
#------------------------------------------------------------------------------------------------------------------------------------------------
func attack_spike():
	yield(get_tree().create_timer(2), "timeout")
	if dead == false:
		anim_player.play("up")

func attack_lasereye():
	lasereye = lasereye_inst.instance()
	if lasereye_active == false:
		self.add_child(lasereye)
		lasereye_active = true
		can_attack = false
		
	attack_timer.start()

func attack_groundeye():
	groundeye = groundeye_inst.instance()
	if groundeye_active == false:
		self.add_child(groundeye)
		groundeye.groundeye_active = true
		groundeye_active = true
		can_attack = false
		
	attack_timer.start()
	pass
#------------------------------------------------------------------------------------------------------------------------------------------------
func _on_anim_player_animation_finished(anim_name):
	yield(get_tree().create_timer(3), "timeout")
	if dead != true:
		if anim_name == "up" and dead != true:
			anim_player.play("down")
		if anim_name == "down" and dead != true:
			anim_player.play("normal")
			can_attack = false
			attack_timer.start()
#------------------------------------------------------------------------------------------------------------------------------------------------
func _on_attack_timer_timeout():
	lasereye_active = false
	groundeye_active = false
	rand = true
	can_attack = true

func _on_anim_fade_animation_finished(anim_name):
	if anim_name == "fade-in":
		bg_spr.texture = load("res://Assets/Enemies/Boss_MotherEye/bg4_dead.png")
		fade_white.play("full_color")
		$MotherEyer_Boss.queue_free()
		yield(get_tree().create_timer(3), "timeout")
		fade_white.play("fade-out")
	if anim_name == "fade-out":
		fade_white.play("normal")
		yield(get_tree().create_timer(4), "timeout")
		fade_black.play("fade-in")

func _on_anim_fade_black_animation_finished(anim_name):
	if anim_name == "fade-in":
		fade_black.play("full_color")
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://Scenes/Credits_Screen.tscn")

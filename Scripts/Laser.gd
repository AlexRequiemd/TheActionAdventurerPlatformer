extends Node2D
onready var orb_sprite = $sorite_2
onready var laser_sprite = $sprite_1
onready var audio_manager = $audio_manager
onready var damage_hitbox = $hitbox/attack_hitbox
onready var damage_hitbox_area = $hitbox
onready var hit_timer = $hit_timer
export var atk_value = 20
var horizontal = true
var exist = true
var hit = 0
var out = false
var sfx_damage : AudioStream = load("res://Sounds/SFX/raclure - Damage SFX.wav")

func _ready():
	laser_sprite.play("in")
	if horizontal == true:
		global_position.x = get_parent().body.global_position.x + 23
		global_position.y = get_parent().body.global_position.y
	elif horizontal == false:
		global_position.x = get_parent().body.global_position.x
		global_position.y = get_parent().body.global_position.y - 7

func _physics_process(delta):
	if horizontal == true:
		global_position.x = get_parent().body.global_position.x + 23
		global_position.y = get_parent().body.global_position.y
	elif horizontal == false:
		global_position.x = get_parent().body.global_position.x
		global_position.y = get_parent().body.global_position.y - 7

func _process(delta):
	
	if exist == true:
		if out == true:
			laser_sprite.play("out")
			orb_sprite.visible = false
			hit = 1
		else: pass
	if exist == false:
		hit = 1
		laser_sprite.play("null")
		yield(get_tree().create_timer(.5), "timeout")
		self.visible = false
	
	if hit == 1:
		damage_hitbox_area.monitoring = false
		damage_hitbox.disabled = true
	if hit == 0:
		damage_hitbox.disabled = false
		damage_hitbox_area.monitoring = true
	

func _on_sprite_1_animation_finished():
	var anim = laser_sprite.animation
	
	if anim == "in":
		laser_sprite.play("loop")
		damage_hitbox.disabled = false
	
	if anim == "out":
		laser_sprite.play("null")
		exist = false


func _on_hit_timer_timeout():
	hit = 0
	pass


func _on_hitbox_body_entered(body):
	if body.name == "Player":
		if hit == 0 and body.current_state != body.DEAD:
			audio_manager.play_sfx(sfx_damage)
			body.instance_hit()
			Global.camera.shake(150, 0.4, 100)
			Global.frame_freeze(0.1, 0.4)
			body.hit = true
			body.emit_signal("damaged")
			Global.hp -= atk_value
			hit = 1
			hit_timer.start()
		else: pass

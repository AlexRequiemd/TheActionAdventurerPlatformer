extends Node2D
onready var fog = $fog
onready var fog_timer1 = $fog/Timer1
onready var damage_timer = $damage_timer
onready var audio_manager = $audio_manager
onready var hit_timer = $hit_timer
onready var damage_hitbox = $hitbox/attack_hitbox
onready var damage_hitbox_area = $hitbox
onready var particles = $Particles2D
export var atk_value = 15
var sfx_damage : AudioStream = load("res://Sounds/SFX/raclure - Damage SFX.wav")
var alpha
var hit = 0
var disperse = false

func _ready():
	damage_timer.start()

func _process(delta):
#	player = PLAYER.instance()
	if fog.modulate.a <= .2 and disperse == false:
		alpha = 0
	if fog.modulate.a >= 1 and disperse == false:
		alpha = 1
	
	if hit == 1:
		damage_hitbox_area.monitoring = false
	if hit == 0:
		damage_hitbox_area.monitoring = true
	
	if disperse == true:
		yield(get_tree().create_timer(.5), "timeout")
		fog.modulate.a -= 0.05
		
	
	if fog.modulate.a <= 0 and disperse == true:
		self.queue_free()




func _on_Timer1_timeout():
	if alpha == 1:
		fog.modulate.a -= 0.05
	elif alpha == 0:
		fog.modulate.a += 0.05



func _on_damage_timer_timeout():
	particles.emitting = false
	damage_hitbox.disabled = true
	disperse = true


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
	


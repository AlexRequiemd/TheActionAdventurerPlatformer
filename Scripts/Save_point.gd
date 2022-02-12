extends Node2D
onready var sprite = $Sprite
onready var timer = $Timer
onready var input = $Input
onready var audio_manager = $audio_manager
var sfx_collect : AudioStream = load("res://Sounds/SFX/axilirate_collect_crystal.wav")




func _ready():
	pass



#func _unhandled_key_input(event):
#	if event.is_action_pressed("ui_up"):
#		if Input.is_action_pressed("ui_action"):
#			get_tree().paused = true
#			save_ui.show()

func _on_Timer_timeout():
	var anim = sprite.animation
	if anim == "in":
		sprite.play("out")

func _on_function_area_body_entered(body):
	if body.name == "Player":
		audio_manager.play_sfx(sfx_collect)
		Global.hp = Global.max_hp
		Global.mp = Global.max_mp
		input.show()
		

func _on_function_area_body_exited(body):
	if body.name == "Player":
		input.hide()

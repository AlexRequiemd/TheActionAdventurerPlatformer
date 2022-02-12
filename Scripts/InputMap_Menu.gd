extends Control
onready var gamepad_gui = $Gamepad_input
onready var button_group = $Button_group
onready var gpad_anim = $Gamepad_input/anim
onready var hint = $hint2
onready var audio_manager = $audio_manager
var sfx_cursor : AudioStream = load("res://Sounds/SFX/ui_cursor.wav")
var sfx_accept : AudioStream = load("res://Sounds/SFX/ui_accept.wav")
var sfx_cancel : AudioStream = load("res://Sounds/SFX/ui_cancel.wav")
var gpad_mode = false
var gpad_type = 0

func _ready():
	gpad_anim.current_animation = "default"

func _process(delta):
	if gpad_mode == true:
		gpadgui_control()
	
	if hint.modulate.a <= 0:
		hint.modulate.a = 1

func _unhandled_input(event):
	if self.visible == true:
		if event.is_action_released("ui_start") and gpad_mode == false:
			audio_manager.play_sfx(sfx_accept)
			button_group.visible = false
			gamepad_gui.visible = true
			gpad_mode = true
		elif event.is_action_released("ui_start") and gpad_mode == true:
			audio_manager.play_sfx(sfx_cancel)
			button_group.visible = true
			gamepad_gui.visible = false
			gpad_mode = false
	else: pass
	
	if event.is_action_released("ui_cancel"):
		button_group.visible = true
		gamepad_gui.visible = false
		gpad_mode = false
		self.hide()

func gpadgui_control():
	if Input.is_action_just_pressed("ui_right") and gpad_type == 0:
		gpad_anim.current_animation = "in"
		gpad_type = 1
	elif Input.is_action_just_pressed("ui_right") and gpad_type == 1:
		pass
	
	if Input.is_action_just_pressed("ui_left") and gpad_type == 1:
		gpad_anim.current_animation = "out"
		gpad_type = 0
	elif Input.is_action_just_pressed("ui_left") and gpad_type == 0:
		pass


func _on_hint_timer_timeout():
	hint.modulate.a -= 0.05

extends Node

var player
var partner
var hp = 100
var max_hp = 100
var mp = 20
var max_mp = 20
var coins = 0
var hit_side = 0
var e_hit_side = 0
var player_atk = 10
var current_enemy = null
var camera = null
var dialogue_happen = false
var player_inial_map_position = Vector2(96, 272)
var player_current_spawn_pos = Vector2(96, 272)
var player_facing_direction = 1
var current_cell
var scene_index
const SAVE_DIR = "user//saves/"
var save_path = SAVE_DIR + "save.dat"

var cell_data = {}

var upgrades = {
	slide = true, double_jump = true, rush = true,
	fireball = true, red_sword = true, best_shield = true
}

var keybinds = {}
var audio = {}
var video = {}
var filepath = "res://configfile.ini"
var configfile

#var transitioner: Transitioner = null

func _ready():
	_set_cell_data()
	configfile = ConfigFile.new()
	if configfile.load(filepath) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			
			if str(key_value) != " ":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
				
		for key in configfile.get_section_keys("audio"):
			var audio_value = configfile.get_value("audio", key)
			
			if str(audio_value) != " ":
				audio[key] = audio_value
			else:
				audio[key] = null
		
		for key in configfile.get_section_keys("video"):
			var video_value = configfile.get_value("video", key)
			
			if str(video_value) != " ":
				video[key] = video_value
			else:
				video[key] = null
		
	else:
		print("CONFIG FILE NOT FOUND")
		get_tree().quit()
	_set_game_binds()
	_set_resolution()
	set_gamepad()
	
func _physics_process(delta):
	if hp <= 0:
		hp = 0
	if hp >= max_hp:
		hp = max_hp
	if mp <= 0:
		mp = 0
	if mp >= max_mp:
		mp = max_mp
	if upgrades.red_sword == true:
		player_atk = 25

func frame_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1.0

func set_gamepad():
	if InputMap.has_action("ui_left"):
		var event_gpad = InputEventJoypadButton.new()
		var event_gpad_axis = InputEventJoypadMotion.new()
		event_gpad.button_index = JOY_DPAD_LEFT
		event_gpad_axis.axis = JOY_AXIS_0
		event_gpad_axis.axis_value = -1.0
		InputMap.action_add_event("ui_left", event_gpad)
		InputMap.action_add_event("ui_left", event_gpad_axis)
	
	if InputMap.has_action("ui_right"):
		var event_gpad = InputEventJoypadButton.new()
		var event_gpad_axis = InputEventJoypadMotion.new()
		event_gpad.button_index = JOY_DPAD_RIGHT
		event_gpad_axis.axis = JOY_AXIS_0
		event_gpad_axis.axis_value = +1.0
		InputMap.action_add_event("ui_right", event_gpad)
		InputMap.action_add_event("ui_right", event_gpad_axis)
	
	if InputMap.has_action("ui_up"):
		var event_gpad = InputEventJoypadButton.new()
		var event_gpad_axis = InputEventJoypadMotion.new()
		event_gpad.button_index = JOY_DPAD_UP
		event_gpad_axis.axis = JOY_AXIS_1
		event_gpad_axis.axis_value = -1.0
		InputMap.action_add_event("ui_up", event_gpad)
		InputMap.action_add_event("ui_up", event_gpad_axis)
	
	if InputMap.has_action("ui_down"):
		var event_gpad = InputEventJoypadButton.new()
		var event_gpad_axis = InputEventJoypadMotion.new()
		event_gpad.button_index = JOY_DPAD_DOWN
		event_gpad_axis.axis = JOY_AXIS_1
		event_gpad_axis.axis_value = +1.0
		InputMap.action_add_event("ui_down", event_gpad)
		InputMap.action_add_event("ui_down", event_gpad_axis)
	
	if InputMap.has_action("ui_select"):
		var event_gpad = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_0
		InputMap.action_add_event("ui_select", event_gpad)
	
	if InputMap.has_action("ui_accept"):
		var event_gpad = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_0
		InputMap.action_add_event("ui_accept", event_gpad)
	
	if InputMap.has_action("ui_action"):
		var event_gpad = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_2
		InputMap.action_add_event("ui_action", event_gpad)
	
	if InputMap.has_action("ui_defense"):
		var event_gpad = InputEventJoypadButton.new()
		var event_gpad2 = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_1
		event_gpad2.button_index = JOY_BUTTON_4
		InputMap.action_add_event("ui_defense", event_gpad)
		InputMap.action_add_event("ui_defense", event_gpad2)
	
	if InputMap.has_action("ui_cancel"):
		var event_gpad = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_1
		InputMap.action_add_event("ui_cancel", event_gpad)
	
	if InputMap.has_action("ui_magic"):
		var event_gpad = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_3
		InputMap.action_add_event("ui_magic", event_gpad)
	
	if InputMap.has_action("ui_start"):
		var event_gpad = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_11
		InputMap.action_add_event("ui_start", event_gpad)
	
	if InputMap.has_action("ui_map"):
		var event_gpad = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_10
		InputMap.action_add_event("ui_map", event_gpad)
	
	if InputMap.has_action("ui_shift"):
		var event_gpad = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_5
		InputMap.action_add_event("ui_shift", event_gpad)
	
	if InputMap.has_action("ui_minimap_toggle"):
		var event_gpad = InputEventJoypadButton.new()
		event_gpad.button_index = JOY_BUTTON_9
		InputMap.action_add_event("ui_minimap_toggle", event_gpad)

func register_player(in_player, in_partner):
	player = in_player
	partner = in_partner

func _set_game_binds():
#	var new_key = InputEventKey.new()
#	InputMap.action_erase_events("ui_action")
#	new_key.set_scancode(keybinds.ui_action.scancode)
#	InputMap.action_add_event("ui_action", new_key)
#	print(new_key)

#	for value in keybinds.values():
#		print(value)
#
	for key in keybinds.keys():
		var value = keybinds[key]
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
		
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value)
			InputMap.action_add_event(key, new_key)
	pass

func _set_resolution():
	if video.resolution == 0:
		OS.window_size = Vector2(1024, 576)
		get_tree().root.set_size(Vector2(1024, 576))
	if video.resolution == 1:
		OS.window_size = Vector2(1280, 720)
		get_tree().root.set_size(Vector2(1280, 720))
	if video.resolution == 2:
		OS.window_size = Vector2(1152, 648)
		get_tree().root.set_size(Vector2(1152, 648))
	if video.resolution == 3:
		OS.window_size = Vector2(896, 504)
		get_tree().root.set_size(Vector2(896, 504))
	if video.resolution == 4:
		OS.window_size = Vector2(768, 432)
		get_tree().root.set_size(Vector2(768, 432))
	if video.resolution == 5:
		OS.window_size = Vector2(640, 360)
		get_tree().root.set_size(Vector2(640, 360))

func _set_cell_data():
	cell_data = {
		"cel_0" : true,
		"cel_1" : true,
		"cel_2" : true,
		"cel_3" : true,
		"cel_4" : true,
		"cel_5" : true,
		"cel_6" : true,
		"cel_7" : true,
		"cel_8" : true,
		"cel_9" : true,
		"cel_10" : true,
		"cel_11" : true,
		"cel_12" : true,
		"cel_13" : true,
		"cel_14" : true,
		"cel_15" : true,
		"cel_16" : true,
		"cel_17" : true,
		"cel_18" : true,
		"cel_19" : true,
		"cel_20" : true,
		"cel_21" : true,
		"cel_22" : true,
	}

func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybinds", key, key_value)
		else:
			configfile.set_value("keybinds", key, " ")
	for key in audio.keys():
		var audio_value = audio[key]
		if audio_value != null:
			configfile.set_value("audio", key, audio_value)
		else:
			configfile.set_value("audio", key, " ")
	for key in video.keys():
		var video_value = video[key]
		if video_value != null:
			configfile.set_value("video", key, video_value)
		else:
			configfile.set_value("video", key, " ")
	
	configfile.save(filepath)

extends Control


onready var audio_manager = $audio_manager
onready var loading = $Loading_popup
onready var pls_wait = $Loading_popup/Panel/please_wait
onready var message_loading = $Loading_popup/Panel/message
onready var succes_load = $Loading_popup/Panel/succes_loaded
onready var load_timer = $load_timer
var sfx_cursor : AudioStream = load("res://Sounds/SFX/ui_cursor.wav")
var sfx_accept : AudioStream = load("res://Sounds/SFX/ui_accept.wav")
var sfx_cancel : AudioStream = load("res://Sounds/SFX/ui_cancel.wav")
var sfx_newgame : AudioStream = load("res://Sounds/SFX/ui_newgame.wav")



func _ready():
#	$LoadGame/Panel/VBoxContainer/yes.grab_focus()
	pass

func _on_yes_pressed():
	audio_manager.play_sfx(sfx_accept)
	var file = File.new()
	if file.file_exists(Global.save_path):
		var error = file.open_encrypted_with_pass(Global.save_path, File.READ, "PASSWORD")
		if error == OK:
			var data = file.get_var()
			
			Global.player_inial_map_position = data.global_player_position
			Global.player_facing_direction = data.global_player_direction
			Global.hp = data.player_hp
			Global.max_hp = data.player_max_hp
			Global.mp = data.player_mp
			Global.max_mp = data.player_max_mp
			Global.scene_index = data.scene_index
			Global.cell_data = data.cell_data
			Global.upgrades = data.upgrades
			
	loading.show()
	$LoadGame/Panel/VBoxContainer/yes.release_focus()
	load_timer.start()

func _on_no_pressed():
	audio_manager.play_sfx(sfx_cancel)
	self.hide()

func _on_yes_focus_exited():
	audio_manager.play_sfx(sfx_cursor)

func _on_no_focus_exited():
	audio_manager.play_sfx(sfx_cursor)

func _on_load_timer_timeout():
	audio_manager.play_sfx(sfx_newgame)
	pls_wait.hide()
	message_loading.hide()
	succes_load.show()
	yield(get_tree().create_timer(2.0), "timeout")
	pls_wait.show()
	message_loading.show()
	succes_load.hide()
	$Loading_popup/loading_bg.hide()
	$Loading_popup/Panel.hide()
#	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene(Global.scene_index)

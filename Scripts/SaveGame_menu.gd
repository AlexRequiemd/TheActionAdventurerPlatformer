extends CanvasLayer

onready var save_ui = $SaveGame
onready var audio_manager = $audio_manager
onready var saving = $Saving_popup
onready var pls_wait = $Saving_popup/Panel/please_wait
onready var message_saving = $Saving_popup/Panel/message
onready var succes_save = $Saving_popup/Panel/succes_saved
onready var save_timer = $saving_timer
var sfx_cursor : AudioStream = load("res://Sounds/SFX/ui_cursor.wav")
var sfx_accept : AudioStream = load("res://Sounds/SFX/ui_accept.wav")
var sfx_cancel : AudioStream = load("res://Sounds/SFX/ui_cancel.wav")
var sfx_newgame : AudioStream = load("res://Sounds/SFX/ui_newgame.wav")
var player_position
var cell_data = {}


func _ready():
	pass
	

func _on_yes_pressed():
	player_position = get_parent().player_global_position
	audio_manager.play_sfx(sfx_accept)
	Global.player_inial_map_position = player_position
	var data = {
		"global_player_position" : Global.player_inial_map_position,
		"global_player_direction" : Global.player_facing_direction,
		"player_hp" : Global.hp,
		"player_max_hp" : Global.max_hp,
		"player_mp" : Global.mp,
		"player_max_mp" : Global.max_mp,
		"scene_index" : Global.scene_index,
		"cell_data" : Global.cell_data,
		"upgrades" : Global.upgrades
	}
	
	var dir = Directory.new()
	if !dir.dir_exists(Global.SAVE_DIR):
		dir.make_dir_recursive(Global.SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(Global.save_path, File.WRITE, "PASSWORD")
	if error == OK:
		file.store_var(data)
		file.close()
	
	saving.show()
	$SaveGame/Panel/VBoxContainer/yes.release_focus()
	save_timer.start()


func _on_no_pressed():
	audio_manager.play_sfx(sfx_cancel)
	get_tree().paused = false
	save_ui.hide()


func _on_yes_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_no_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_SaveGame_visibility_changed():
	$SaveGame/Panel/VBoxContainer/yes.grab_focus()


func _on_saving_timer_timeout():
	audio_manager.play_sfx(sfx_newgame)
	pls_wait.hide()
	message_saving.hide()
	succes_save.show()
	yield(get_tree().create_timer(2.0), "timeout")
	pls_wait.show()
	message_saving.show()
	succes_save.hide()
	saving.hide()
#	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().paused = false
	save_ui.hide()
	

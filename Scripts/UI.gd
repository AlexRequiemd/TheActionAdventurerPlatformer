extends CanvasLayer
var sfx_cursor : AudioStream = load("res://Sounds/SFX/ui_cursor.wav")
var sfx_accept : AudioStream = load("res://Sounds/SFX/ui_accept.wav")
var sfx_cancel : AudioStream = load("res://Sounds/SFX/ui_cancel.wav")
var sfx_quit : AudioStream = load("res://Sounds/SFX/hero_quit.wav")
var sfx_retry : AudioStream = load("res://Sounds/SFX/hero_retry.wav")
onready var pause = $pause/Ui1
onready var failed = $failed/Ui2
onready var audio_manager = $audio_manager
onready var pause_ui = $pause/Ui1
onready var map_ui = $pause/Map_UI
onready var map = $pause/Map_UI/ViewportContainer/Viewport/Map
onready var map_arrows = $pause/Map_UI/MapFrame_2
onready var map_ui_timer = $pause/Map_UI/map_ui_timer
var map_mode = false

func _ready():
	pass

func _unhandled_input(event):
	if event.is_action_released("ui_start"):
		get_tree().paused = true
		pause.show()
		$pause/Ui1/Panel/VBoxContainer/resume.grab_focus()
	
	if (event.is_action_released("ui_cancel") or event.is_action_released("ui_map")) and (map_ui.visible == true) and (map_mode != true):
		audio_manager.play_sfx(sfx_cancel)
		map_ui.hide()
		pause_ui.show()
		map.map_cam_mode = false
		$pause/Ui1/Panel/VBoxContainer/map.grab_focus()
	
	if event.is_action_released("ui_map") and (map_mode == false) and (pause.visible == false):
		audio_manager.play_sfx(sfx_accept)
		get_tree().paused = true
		map_mode = true
		map.map_cam_mode = true
		pause_ui.hide()
		map_ui.show()
		pause.show()
	elif (event.is_action_released("ui_cancel") or event.is_action_released("ui_map")) and (map_mode == true):
		audio_manager.play_sfx(sfx_cancel)
		get_tree().paused = false
		map_mode = false
		map.map_cam_mode = false
		pause_ui.show()
		map_ui.hide()
		pause.hide()
	
	if (pause.visible == true) and (map_ui.visible == false):
		if event.is_action_pressed("ui_cancel"):
			audio_manager.play_sfx(sfx_cancel)
			get_tree().paused = false
			map_mode = false
			pause_ui.show()
			map_ui.hide()
			pause.hide()
	

func _physics_process(delta):
	if map_arrows.modulate.a <= 0:
		map_arrows.modulate.a = 1

func failed():
	failed.show()
	$failed/Ui2/Panel/VBoxContainer/try_again.grab_focus()

func _on_resume_pressed():
	get_tree().paused = false
	audio_manager.play_sfx(sfx_cancel)
	pause.hide()

func _on_try_again_pressed():
	audio_manager.play_sfx(sfx_retry)
	yield(get_tree().create_timer(1.60), "timeout")
	Global.player_inial_map_position = Global.player_current_spawn_pos
	get_tree().reload_current_scene()
	Global.hp = Global.max_hp

func _on_main_menu_pressed():
	get_tree().paused = false
	audio_manager.play_sfx(sfx_accept)
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://Scenes/Menu.tscn")

func _on_quit_menu_pressed():
	get_tree().paused = false
	audio_manager.play_sfx(sfx_quit)
	yield(get_tree().create_timer(1.10), "timeout")
	get_tree().change_scene("res://Scenes/Menu.tscn")

func _on_map_pressed():
	audio_manager.play_sfx(sfx_accept)
	$pause/Ui1/Panel/VBoxContainer/map.release_focus()
	map.map_cam_mode = true
	map_ui.show()

func _on_resume_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_main_menu_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_try_again_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_quit_menu_focus_exited():
	audio_manager.play_sfx(sfx_cursor)

func _on_map_focus_exited():
	audio_manager.play_sfx(sfx_cursor)







func _on_map_ui_timer_timeout():
	map_arrows.modulate.a -= 0.05

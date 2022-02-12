extends Control
var music_title : AudioStream = load("res://Sounds/BGM/jackfluck - Fantasy Style Loop.wav")
var sfx_cursor : AudioStream = load("res://Sounds/SFX/ui_cursor.wav")
var sfx_accept : AudioStream = load("res://Sounds/SFX/ui_accept.wav")
var sfx_cancel : AudioStream = load("res://Sounds/SFX/ui_cancel.wav")
var sfx_newgame : AudioStream = load("res://Sounds/SFX/ui_newgame.wav")
onready var menu = $Menu
onready var press_enter = $Press_enter
onready var camera = $Camera2D
onready var Tile_Map = $TileMap
onready var audio_manager = $audio_manager
onready var menu_settings = $Menu_Settings
onready var load_ui = $LoadGame_menu
onready var title_logo = $Title

func _ready():
	var tilemap_rect = Tile_Map.get_used_rect()
	var tilemap_cell_size = Tile_Map.cell_size
	camera.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	camera.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	camera.limit_top = tilemap_rect.position.y * tilemap_cell_size.y
	camera.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
	yield(get_tree().create_timer(.5), "timeout")
	audio_manager.play_music(music_title)

func _process(delta):
	if press_enter.modulate.a <= 0:
		press_enter.modulate.a = 1

func _unhandled_input(event):
	if press_enter.visible == true:
		if event.is_action_released("ui_select"):
			press_enter.hide()
			title_logo.hide()
			audio_manager.play_sfx(sfx_accept)
			menu.show()
			$Menu/VBoxContainer/new_game.grab_focus()
		elif event.is_action_released("ui_start"):
			press_enter.hide()
			title_logo.hide()
			audio_manager.play_sfx(sfx_accept)
			menu.show()
			$Menu/VBoxContainer/new_game.grab_focus()
	else: pass
	

func _on_new_game_pressed():
	audio_manager.play_sfx(sfx_newgame)
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_quit_game_pressed():
	audio_manager.play_sfx(sfx_accept)
	yield(get_tree().create_timer(.2), "timeout")
	get_tree().quit()


func _on_continue_pressed():
	audio_manager.play_sfx(sfx_accept)
	load_ui.show()
	$Menu/VBoxContainer/continue.release_focus()


func _on_settings_pressed():
	audio_manager.play_sfx(sfx_accept)
	menu_settings.show()


func _on_new_game_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_continue_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_settings_focus_exited():
	audio_manager.play_sfx(sfx_cursor)

func _on_quit_game_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_Menu_Settings_hide():
	$Menu/VBoxContainer/settings.grab_focus()


func _on_Menu_Settings_visibility_changed():
	if $Menu_Settings.visible:
		$Menu_Settings/Menu/VBoxContainer/audio_button.grab_focus()


func _on_LoadGame_menu_hide():
	$Menu/VBoxContainer/continue.grab_focus()


func _on_LoadGame_menu_visibility_changed():
	if load_ui.visible:
		$LoadGame_menu/LoadGame/Panel/VBoxContainer/yes.grab_focus()


func _on_press_timer_timeout():
	press_enter.modulate.a -= 0.05

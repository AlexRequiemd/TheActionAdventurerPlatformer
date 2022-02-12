extends Control
onready var audio_manager = $audio_manager
onready var option_label = $Options/Container/Option_label
onready var controls_option = $InputMap_Menu
onready var audio_option = $Audio_Menu
onready var video_option = $Video_Menu
onready var resolution_option = $Options/Video/OptionButton
onready var buttoncontainer = $Options/Controls/ScrollContainer/Controls_Container
onready var music_slider = $Audio_Menu/Slider_group/VBoxContainer/Slider_M/slider_bgm
onready var sound_slider = $Audio_Menu/Slider_group/VBoxContainer/Slider_M/slider_sfx
onready var buttonscript = load("res://Scripts/KeyButton.gd")
onready var button_font = load("res://Prefabs/Dynamic_Fonts/UI_font.tres")
onready var save_popup = $save_popup
onready var desc_label = $Descript_label
var sfx_cursor : AudioStream = load("res://Sounds/SFX/ui_cursor.wav")
var sfx_accept : AudioStream = load("res://Sounds/SFX/ui_accept.wav")
var sfx_cancel : AudioStream = load("res://Sounds/SFX/ui_cancel.wav")
var ItemListContent = ["1920x1080", "1280x720", "1152x648", "1024x576", "896x504", "768x432", "640x360","1024x768", "800x600", "640x480"]
var keybinds
var audio
var video
var buttons = {}

func _ready():
#	$Menu/VBoxContainer/audio_button.grab_focus()
#	music_slider.value = Global.audio.music_volume
#	fx_slider.value = Global.audio.fx_volume
#	OS.window_resizable = !Global.video.borderless
#	$Options/Video/check_fullscreen.pressed = Global.video.fullscreen
#	$Options/Video/check_borderless.pressed = Global.video.borderless
#	$Options/Video/check_vsync.pressed = Global.video.vsync
	
	keybinds = Global.keybinds.duplicate()
	audio = Global.audio.duplicate()
	video = Global.video.duplicate()

	#CONTROL MENU CREATION
#	for key in keybinds.keys():
#		var hbox = HBoxContainer.new()
#		var label = Label.new()
#		var button = Button.new()
#
#		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
#		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
#		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
#
#		label.text = key
#
#		var button_value = keybinds[key]
#		if button_value != null:
#			button.text = OS.get_scancode_string(button_value)
#		else:
#			button.text = "Unassigned"
#
#		button.set_script(buttonscript)
#		button.key = key
#		button.value = button_value
#		button.menu = self
#		button.toggle_mode = true
#		button.focus_mode = Control.FOCUS_NONE
#
#		hbox.add_child(label)
#		hbox.add_child(button)
#		buttoncontainer.add_child(hbox)
#
#		buttons[key] = button
	
	
	#LOAD OPTION_BUTTON CONTENT
#	for ItemID in range(10):
#		resolution_option.add_item(ItemListContent[ItemID],ItemID)
#	resolution_option.select(Global.video.resolution) #This sets a default so we don't
#	# have to do error catching if an empty selection is captured.
#	resolution_option.connect("pressed",self,"ReportListItem")

#func ReportListItem():
#	var ItemNo = resolution_option.get_selected()
#	#The output ItemNo is the number of the selected item
#	var SelectedItemtext = ItemListContent[ItemNo]
#	resolution_option.set_text("select")

#func _on_music_slider_value_changed(value):
#	audio.music_volume = value
#	AudioServer.set_bus_volume_db(1, lerp(AudioServer.get_bus_volume_db(1), value, 0.5))
#	if value == -20:
#		audio.music_disabled = true
#		AudioServer.set_bus_mute(1, true)
#	else:
#		audio.music_disabled = false
#		AudioServer.set_bus_mute(1, false)
#
#func _on_soundfx_slider_value_changed(value):
#	audio_manager.play_sfx(sfx_cursor)
#	audio.fx_volume = value
#	AudioServer.set_bus_volume_db(2, lerp(AudioServer.get_bus_volume_db(2), value, 0.5))
#	if value == -20:
#		audio.fx_disabled = true
#		AudioServer.set_bus_mute(2, true)
#	else:
#		audio.fx_disabled = false
#		AudioServer.set_bus_mute(2, false)

#func _on_check_borderless_toggled(button_pressed):
#	audio_manager.play_sfx(sfx_accept)
#	video.borderless = button_pressed
#	OS.window_borderless = button_pressed
#	OS.window_resizable = !button_pressed
#
#func _on_check_fullscreen_toggled(button_pressed):
#	audio_manager.play_sfx(sfx_accept)
#	video.fullscreen = button_pressed
#	OS.window_fullscreen = button_pressed
#
#func _on_check_vsync_toggled(button_pressed):
#	audio_manager.play_sfx(sfx_accept)
#	video.vsync = button_pressed
#	OS.vsync_enabled = button_pressed
#
#func _on_OptionButton_item_selected(index):
#	video.resolution = index
#
#	if index == 0:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(1920, 1080)
#		get_tree().root.set_size(Vector2(1920, 1080))
#	if index == 1:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(1280, 720)
#		get_tree().root.set_size(Vector2(1280, 720))
#	if index == 2:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(1152, 648)
#		get_tree().root.set_size(Vector2(1152, 648))
#	if index == 3:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(1024, 576)
#		get_tree().root.set_size(Vector2(1024, 576))
#	if index == 4:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(896, 504)
#		get_tree().root.set_size(Vector2(896, 504))
#	if index == 5:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(768, 432)
#		get_tree().root.set_size(Vector2(768, 432))
#	if index == 6:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(640, 360)
#		get_tree().root.set_size(Vector2(640, 360))
#	if index == 7:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(1024, 768)
#		get_tree().root.set_size(Vector2(1024, 768))
#	if index == 8:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(800, 600)
#		get_tree().root.set_size(Vector2(800, 600))
#	if index == 9:
#		audio_manager.play_sfx(sfx_accept)
#		OS.window_size = Vector2(640, 480)
#		get_tree().root.set_size(Vector2(640, 480))
#
#
#	if index == 0:
#		audio_manager.play_sfx(sfx_cursor)
#	if index == 1:
#		audio_manager.play_sfx(sfx_cursor)
#	if index == 2:
#		audio_manager.play_sfx(sfx_cursor)
#	if index == 3:
#		audio_manager.play_sfx(sfx_cursor)
#	if index == 4:
#		audio_manager.play_sfx(sfx_cursor)
#	if index == 5:
#		audio_manager.play_sfx(sfx_cursor)
#	if index == 6:
#		audio_manager.play_sfx(sfx_cursor)
#	if index == 7:
#		audio_manager.play_sfx(sfx_cursor)
#	if index == 8:
#		audio_manager.play_sfx(sfx_cursor)
#	if index == 9:
#		audio_manager.play_sfx(sfx_cursor)


func change_bind(key, value):
	keybinds[key] = value
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			keybinds[k] = null
			keybinds[k].value = null
			buttons[k].text = "Unassigned"

func _on_audio_button_pressed():
	audio_manager.play_sfx(sfx_accept)
	controls_option.hide()
	video_option.hide()
	$Options.hide()
	$Menu.hide()
	desc_label.hide()
	audio_option.show()
	option_label.text = " "
	$Audio_Menu/Slider_group/VBoxContainer/Slider_M/slider_bgm.grab_focus()
	

func _on_video_button_pressed():
	audio_manager.play_sfx(sfx_accept)
	controls_option.hide()
	audio_option.hide()
	$Options.hide()
	$Menu.hide()
	desc_label.hide()
	video_option.show()
	option_label.text = " "
	

func _on_controls_button_pressed():
	audio_manager.play_sfx(sfx_accept)
	audio_option.hide()
	video_option.hide()
	$Options.hide()
	$Menu.hide()
	desc_label.hide()
	controls_option.show()
	option_label.text = " "
	$InputMap_Menu/Button_group/Input_container/Input_List/Button_container/Button.grab_focus()
	

func _on_back_button_pressed():
	audio_manager.play_sfx(sfx_cancel)
	save_popup.show()
	$save_popup/Panel/save_button.grab_focus()

func _on_save_button_pressed():
	audio_manager.play_sfx(sfx_accept)
	Global.audio = audio
	Global.video = video
	Global._set_game_binds()
	Global.write_config()
	Global.set_gamepad()
	save_popup.hide()
	audio_option.hide()
	video_option.hide()
	controls_option.hide()
	self.hide()

func _on_nosave_button_pressed():
	audio_manager.play_sfx(sfx_cancel)
	Global.audio = Global.audio
	Global.video = Global.video
	OS.window_borderless = Global.video.borderless
	OS.window_resizable = Global.video.borderless
	OS.vsync_enabled = Global.video.vsync
	OS.window_fullscreen = Global.video.fullscreen
	Global.keybinds = keybinds
	Global.set_gamepad()
	save_popup.hide()
	audio_option.hide()
	video_option.hide()
	controls_option.hide()
	self.hide()

func _on_audio_button_focus_exited():
	audio_manager.play_sfx(sfx_cursor)

func _on_video_button_focus_exited():
	audio_manager.play_sfx(sfx_cursor)

func _on_controls_button_focus_exited():
	audio_manager.play_sfx(sfx_cursor)

func _on_back_button_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_audio_button_focus_entered():
	desc_label.text = "Set the volume of Music and Sound Effects"


func _on_video_button_focus_entered():
	desc_label.text = "Set the Resolution, Fullscreen, Vsync and Window Border"


func _on_controls_button_focus_entered():
	desc_label.text = "Set the Control Inputs (Only Keyboard)"


func _on_back_button_focus_entered():
	desc_label.text = " "


func _on_save_button_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_nosave_button_focus_exited():
	audio_manager.play_sfx(sfx_cursor)


func _on_InputMap_Menu_hide():
	audio_manager.play_sfx(sfx_accept)
	audio_option.hide()
	video_option.hide()
	$Options.show()
	$Menu.show()
	desc_label.show()
	option_label.text = " "
	$Menu/VBoxContainer/controls_button.grab_focus()


func _on_Audio_Menu_hide():
	audio_manager.play_sfx(sfx_accept)
	audio = audio_option.audio
	controls_option.hide()
	video_option.hide()
	$Options.show()
	$Menu.show()
	desc_label.show()
	option_label.text = " "
	$Menu/VBoxContainer/audio_button.grab_focus()


func _on_Video_Menu_hide():
	audio_manager.play_sfx(sfx_accept)
	video = video_option.video
	controls_option.hide()
	audio_option.hide()
	$Options.show()
	$Menu.show()
	desc_label.show()
	option_label.text = " "
	$Menu/VBoxContainer/video_button.grab_focus()

extends Control
onready var resolution_button = $Buttons_group/Resolution/ResolutionBg/resolution_button
onready var fullscreen_button = $Buttons_group/Fullscreen/FullscreenBg/fullscreen_button
onready var borderless_button = $Buttons_group/Borderless/BorderlessBg/borderless_button
onready var vsync_button = $Buttons_group/Vsync/VsyncBg/vsync_button
onready var borderless_bg = $Buttons_group/Borderless/BorderlessBg
onready var audio_manager = $audio_manager
var sfx_cursor : AudioStream = load("res://Sounds/SFX/ui_cursor.wav")
var sfx_accept : AudioStream = load("res://Sounds/SFX/ui_accept.wav")
var sfx_cancel : AudioStream = load("res://Sounds/SFX/ui_cancel.wav")
var video = {borderless = false, fullscreen = false, vsync = false, resolution = 0}
var ItemListContent = ["1024x576", "1280x720", "1152x648", "896x504", "768x432", "640x360"]

func _ready():
	OS.window_resizable = !Global.video.borderless
	fullscreen_button.pressed = Global.video.fullscreen
	borderless_button.pressed = Global.video.borderless
	vsync_button.pressed = Global.video.vsync
	#LOAD OPTION_BUTTON CONTENT
	for ItemID in range(6):
		resolution_button.add_item(ItemListContent[ItemID],ItemID)
	resolution_button.select(Global.video.resolution) #This sets a default so we don't
	# have to do error catching if an empty selection is captured.
	resolution_button.connect("pressed",self,"ReportListItem")

func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		self.hide()

func _on_resolution_button_mouse_exited():
	resolution_button.release_focus()


func _on_fullscreen_button_toggled(button_pressed):
	if button_pressed == true:
		audio_manager.play_sfx(sfx_accept)
	else:
		audio_manager.play_sfx(sfx_cancel)
	var b_enable = button_pressed
	borderless_button.pressed = button_pressed
	borderless_button.disabled = button_pressed
	
	video.fullscreen = button_pressed
	OS.window_fullscreen = button_pressed
	
	if b_enable == true:
		borderless_bg.texture = load("res://Assets/UI/check_button/check_borderless_bg_disabled.png")
	else:
		borderless_bg.texture = load("res://Assets/UI/check_button/check_borderless_bg.png")	


func _on_borderless_button_toggled(button_pressed):
	if button_pressed == true:
		audio_manager.play_sfx(sfx_accept)
	else:
		audio_manager.play_sfx(sfx_cancel)
	video.borderless = button_pressed
	OS.window_borderless = button_pressed
	OS.window_resizable = !button_pressed


func _on_vsync_button_toggled(button_pressed):
	if button_pressed == true:
		audio_manager.play_sfx(sfx_accept)
	else:
		audio_manager.play_sfx(sfx_cancel)
	video.vsync = button_pressed
	OS.vsync_enabled = button_pressed

func ReportListItem():
	var ItemNo = resolution_button.get_selected()
	#The output ItemNo is the number of the selected item
	var SelectedItemtext = ItemListContent[ItemNo]
	resolution_button.set_text("select")

func _on_resolution_button_item_selected(index):
	video.resolution = index
	
	if index == 0:
		audio_manager.play_sfx(sfx_accept)
		OS.window_size = Vector2(1024, 576)
		get_tree().root.set_size(Vector2(1024, 576))
	if index == 1:
		audio_manager.play_sfx(sfx_accept)
		OS.window_size = Vector2(1280, 720)
		get_tree().root.set_size(Vector2(1280, 720))
	if index == 2:
		audio_manager.play_sfx(sfx_accept)
		OS.window_size = Vector2(1152, 648)
		get_tree().root.set_size(Vector2(1152, 648))
	if index == 3:
		audio_manager.play_sfx(sfx_accept)
		OS.window_size = Vector2(896, 504)
		get_tree().root.set_size(Vector2(896, 504))
	if index == 4:
		audio_manager.play_sfx(sfx_accept)
		OS.window_size = Vector2(768, 432)
		get_tree().root.set_size(Vector2(768, 432))
	if index == 5:
		audio_manager.play_sfx(sfx_accept)
		OS.window_size = Vector2(640, 360)
		get_tree().root.set_size(Vector2(640, 360))
	
	
	
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


func _on_resolution_button_item_focused(index):
	audio_manager.play_sfx(sfx_cursor)

extends TextureButton
var keybinds
export(String) var action = "ui_up"
onready var text = " "
onready var audio_manager = $audio_manager
var sfx_cursor : AudioStream = load("res://Sounds/SFX/ui_cursor.wav")
var sfx_accept : AudioStream = load("res://Sounds/SFX/ui_accept.wav")
var sfx_cancel : AudioStream = load("res://Sounds/SFX/ui_cancel.wav")

func _ready():
	assert(InputMap.has_action(action))
	set_process_unhandled_key_input(false)
	display_current_key()

func _process(delta):
	$Input_name.text = text

func _toggled(button_pressed):
	set_process_unhandled_key_input(button_pressed)
	if button_pressed:
		text = "... Key"
		release_focus()
	else:
		display_current_key()


func _unhandled_key_input(event):
	# Note that you can use the _input callback instead, especially if
	# you want to work with gamepads.
	if event is InputEventKey:
		remap_action_to(event)
		pressed = false


func remap_action_to(event):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	set_keys(event)
	text = "%s Key" % event.as_text()


func display_current_key():
	var current_key = InputMap.get_action_list(action)[0].as_text()
	text = "%s Key" % current_key

func set_keys(event):
	if action == "ui_left":
		Global.keybinds.ui_left = event.scancode
	
	if action == "ui_right":
		Global.keybinds.ui_right = event.scancode
	
	if action == "ui_up":
		Global.keybinds.ui_up = event.scancode
	
	if action == "ui_down":
		Global.keybinds.ui_down = event.scancode
	
	if action == "ui_action":
		Global.keybinds.ui_action = event.scancode
	
	if action == "ui_shift":
		Global.keybinds.ui_shift = event.scancode
	
	if action == "ui_select":
		Global.keybinds.ui_select = event.scancode
	
	if action == "ui_defense":
		Global.keybinds.ui_defense = event.scancode
	
	if action == "ui_start":
		Global.keybinds.ui_start = event.scancode
	
	if action == "ui_map":
		Global.keybinds.ui_map = event.scancode
	
	if action == "ui_magic":
		Global.keybinds.ui_magic = event.scancode


func _on_Button_focus_exited():
	audio_manager.play_sfx(sfx_cursor)




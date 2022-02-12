extends Node


func _ready():
	pass

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
		event_gpad_axis.axis = JOY_AXIS_2
		event_gpad_axis.axis_value = -1.0
		InputMap.action_add_event("ui_up", event_gpad)
		InputMap.action_add_event("ui_up", event_gpad_axis)
	
	if InputMap.has_action("ui_down"):
		var event_gpad = InputEventJoypadButton.new()
		var event_gpad_axis = InputEventJoypadMotion.new()
		event_gpad.button_index = JOY_DPAD_DOWN
		event_gpad_axis.axis = JOY_AXIS_2
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

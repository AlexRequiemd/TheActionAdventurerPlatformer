extends CanvasLayer
onready var minimap = $Mini_Map

func _ready():
	pass

func _unhandled_input(event):
	if minimap.visible == true:
		if event.is_action_released("ui_minimap_toggle"):
			minimap.visible = false
	elif minimap.visible == false:
		if event.is_action_released("ui_minimap_toggle"):
			minimap.visible = true

func make_invisible_minimap():
	minimap.visible = false

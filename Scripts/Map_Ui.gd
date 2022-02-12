extends Control
export var minimap_enabled = true
onready var map_ui_camera = $Camera_mapmenu
onready var minimap_camera = $Camera_minimap
onready var minimap_cursor = $minmap_cursor
var camera_default_pos = Vector2(0, 0)
var map_cam_mode = false



func _ready():
	pass

func _process(delta):
	_camera_move()
	
	if minimap_enabled == true:
		minimap_camera.current = true
		map_ui_camera.current = false
		minimap_camera.position = lerp(minimap_camera.position, minimap_cursor.position, 0.2)
	
	elif minimap_enabled == false:
		minimap_camera.current = false
		map_ui_camera.current = true
	pass
	
	if map_cam_mode == false:
		map_ui_camera.position = camera_default_pos

func _camera_move():
	if map_ui_camera.current == true and map_cam_mode == true:
		if Input.is_action_pressed("ui_up"):
			map_ui_camera.position.y += -1
		if Input.is_action_pressed("ui_down"):
			map_ui_camera.position.y += 1
		if Input.is_action_pressed("ui_right"):
			map_ui_camera.position.x += 1
		if Input.is_action_pressed("ui_left"):
			map_ui_camera.position.x += -1

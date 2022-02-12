extends Node
onready var save_ui = $SaveGame_menu/SaveGame
var player_position_x = 0
var player_position_y = 0
var menu_can_show = false
var player_global_position
var cell_id
onready var player_camera = $Player/Camera2D

signal force_idle

func _ready():
	player_camera.zoom = Vector2(1, 1)
	Global.scene_index = get_tree().current_scene.filename

func _process(delta):
	if Input.is_action_pressed("ui_up") and (menu_can_show == true):
		if Input.is_action_just_pressed("ui_action"):
			emit_signal("force_idle")
			get_tree().paused = true
			save_ui.show()
	player_position_x = $Player.global_position.x
	player_position_y = $Player.global_position.y
	set_player_global_pos()
	Global.current_cell = cell_id
#	print("Global_cell_id: ", Global.current_cell)
	

func set_player_global_pos():
	player_global_position = Vector2(player_position_x, player_position_y)

func _on_function_area_body_entered(body):
	menu_can_show = true


func _on_function_area_body_exited(body):
	menu_can_show = false

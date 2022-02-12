tool
extends Area2D

onready var changer = get_parent().get_node("Transition_In")
export(String, FILE) var Next_Scene = ""
export(Vector2) var player_spawn_location = Vector2.ZERO
export(Vector2) var player_checkpoint_location = Vector2.ZERO
export(int) var player_direction = 1

func _get_configuration_warning():
	if Next_Scene == "":
		return "Next_Scene path must be selected"
	else:
		return ""

func _on_Scene_change_body_entered(body):
	
	if body.name == "Player":
		Global.player_inial_map_position = player_spawn_location
		Global.player_current_spawn_pos = player_checkpoint_location
		Global.player_facing_direction = player_direction
		changer.change_scene(Next_Scene)

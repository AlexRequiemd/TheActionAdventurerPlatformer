extends Node2D
onready var sprite = $sprite
onready var light = $sprite/Light2D
export var follow_player = true

func _ready():
	pass

func _process(delta):
	if follow_player == true:
		position = global_position.linear_interpolate(Global.partner.global_position, 0.15)
	_enable_light()

func _enable_light():
	if get_parent().is_in_group("dark_area"):
		light.enabled = true
	else:
		light.enabled = false

func _on_ghost_timer_timeout():
	var ghost = preload("res://Prefabs/Ghost_trail_Gal.tscn").instance()
	get_parent().get_parent().add_child(ghost)
	ghost.position = position
	ghost.texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
	ghost.flip_h = sprite.flip_h

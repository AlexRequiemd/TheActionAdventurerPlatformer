extends Node2D
export var type = 0
onready var body = $body
onready var sprite = $body/sprite
var active = false
onready var laser_inst = load("res://Prefabs/Laser_v.tscn")
var laser = null
#------------------------------------------------------------------------------------------------------------------------------------------------
func _ready():
#	if get_parent().attack == true:
#		sprite.play("in")
#		if type == 0:
#			yield(get_tree().create_timer(3), "timeout")
#			sprite.play("charge")
#			yield(get_tree().create_timer(1), "timeout")
#			instance()
#			sprite.play("shoot")
#			if active == true:
#				_start_tween()
#		if type == 1:
#			yield(get_tree().create_timer(6), "timeout")
#			sprite.play("charge")
#			yield(get_tree().create_timer(1), "timeout")
#			instance()
#			sprite.play("shoot")
#			if active == true:
#				_start_tween()
#	else:
#		sprite.play("none")
	pass
#------------------------------------------------------------------------------------------------------------------------------------------------
func _start_tween():
	yield(get_tree().create_timer(2), "timeout")
	tween_completed()
#------------------------------------------------------------------------------------------------------------------------------------------------
func _process(delta):
	pass
#------------------------------------------------------------------------------------------------------------------------------------------------
func instance():
	laser = laser_inst.instance()
	if active == false:
		self.add_child(laser)
		laser.horizontal = false
		active = true
	pass
#------------------------------------------------------------------------------------------------------------------------------------------------
func _attack():
	if get_parent().groundeye_active == true:
		sprite.play("in")
		if type == 0:
			yield(get_tree().create_timer(3), "timeout")
			sprite.play("charge")
			yield(get_tree().create_timer(1), "timeout")
			instance()
			sprite.play("shoot")
			if active == true:
				_start_tween()
		if type == 1:
			yield(get_tree().create_timer(6), "timeout")
			sprite.play("charge")
			yield(get_tree().create_timer(1), "timeout")
			instance()
			sprite.play("shoot")
			if active == true:
				_start_tween()
	else:
		sprite.play("none")
#------------------------------------------------------------------------------------------------------------------------------------------------
func tween_completed():
	laser.out = true
	sprite.play("rest")
	if type == 0:
		yield(get_tree().create_timer(4), "timeout")
	elif type == 1:
		yield(get_tree().create_timer(1), "timeout")
	sprite.play("out")
#------------------------------------------------------------------------------------------------------------------------------------------------
func _on_sprite_animation_finished():
	var anim = sprite.animation
	if anim == "out":
		get_parent().groundeye_active = false
		get_parent().destroy = true
#------------------------------------------------------------------------------------------------------------------------------------------------

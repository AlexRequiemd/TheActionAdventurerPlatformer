extends Node2D
onready var body = $body
onready var sprite = $body/sprite
onready var tween = $Tween
export var speed = 3.0
export var horizontal = false
export var distance = -72
const WAIT_DURATION = 1.0
var follow = Vector2.ZERO
var active = false
onready var laser_inst = load("res://Prefabs/Laser_h.tscn")
var laser = null
#------------------------------------------------------------------------------------------------------------------------------------------------
func _ready():
	global_position.x = 16
	global_position.y = 32
	sprite.play("in")
	yield(get_tree().create_timer(1), "timeout")
	sprite.play("charge")
	yield(get_tree().create_timer(1), "timeout")
	instance()
	sprite.play("shoot")
	if active == true:
		_start_tween()
#------------------------------------------------------------------------------------------------------------------------------------------------
func _start_tween():
	var move_direction = Vector2.RIGHT * distance if horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(speed * 16)
	
	tween.interpolate_property(
		self, "follow", Vector2.ZERO, move_direction, duration, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, WAIT_DURATION
	)
	tween.interpolate_property(
		self, "follow", move_direction, Vector2.ZERO, duration, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + WAIT_DURATION * 2
	)
	tween.start()
#------------------------------------------------------------------------------------------------------------------------------------------------
func _physics_process(delta):
	body.position = body.position.linear_interpolate(follow, 0.05)
	if get_parent().dead == true:
		self.queue_free()
	pass
#------------------------------------------------------------------------------------------------------------------------------------------------
func instance():
	laser = laser_inst.instance()
	if active == false:
		self.add_child(laser)
		laser.horizontal = true
#		laser.global_position.x = self.global_position.x + 23
#		laser.global_position.y = self.global_position.y
		active = true
	pass


func _on_Tween_tween_all_completed():
	laser.out = true
	sprite.play("rest")
	yield(get_tree().create_timer(2), "timeout")
	sprite.play("out")


func _on_sprite_animation_finished():
	var anim = sprite.animation
	if anim == "out":
		self.queue_free()

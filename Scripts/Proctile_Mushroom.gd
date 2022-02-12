extends KinematicBody2D
onready var sprite = $sprite
onready var timer1 = $Timer1
onready var timer2 = $Timer2
var GRAVITY = 10
var JUMP_HEIGHT = 300
var MOVESPEED = 70
var velocity = Vector2.ZERO
var active = false
var dir = 1
onready var smoke = load("res://Prefabs/Smoke_mushroom.tscn")

func _ready():
	velocity.y = -JUMP_HEIGHT

func _physics_process(delta):
	velocity.x = MOVESPEED*dir
	if !is_on_floor():
		sprite.rotation_degrees += 16
	if is_on_floor() and active == false:
		sprite.play("activate")
		timer1.start()
		set_physics_process(false)
#		sprite.play("activate")
#		yield(get_tree().create_timer(2.0), "timeout")
#		sprite.speed_scale = 3
#		yield(get_tree().create_timer(2.0), "timeout")
#		instance()
#	elif is_on_floor() and active == true:
#		sprite.play("explode")
	_gravity(delta)
	_move_and_slide()

func instance():
	var smoke_inst = smoke.instance()
	if active == false:
		get_parent().add_child(smoke_inst)
		smoke_inst.global_position.x = self.position.x
		smoke_inst.global_position.y = self.position.y - 10
		active = true
	pass
	

func _gravity(_delta):
	velocity.y += GRAVITY
	
func _move_and_slide():
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		velocity.x = 0
	pass


func _on_sprite_animation_finished():
	var anim = sprite.animation
	if anim == "explode":
		self.queue_free()
	pass


func _on_Timer1_timeout():
	sprite.speed_scale = 3
	timer2.start()


func _on_Timer2_timeout():
	sprite.play("explode")
	instance()

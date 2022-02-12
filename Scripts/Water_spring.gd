extends Node2D

var velocity = 0 #CURRENT spring velocity
var force = 0 #FORCE applied to spring
var height = 0 #CURRENT spring height
var target_height = 0 #NATURAL spring position
var index = 0 #INDEX for this spring
var motion_factor = 0.02
var collide_with = null

onready var collision = $Area2D/CollisionShape2D #COLLISION for spring

signal splash


func water_update(spring_constant, dampening):
	
	height = position.y
	var x = height - target_height
	var loss = -dampening * velocity
	force = - spring_constant * x + loss
	velocity += force
	position.y += velocity

func initialize(x_position, id):
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = id

func set_collision_width(value):
	var extents = collision.shape.get_extents()
	var new_extents = Vector2(value/2, extents.y)
	collision.shape.set_extents(new_extents)
	pass

func _on_Area2D_body_entered(body):
#	if body == collide_with:
#		return
#	else:
#		collide_with = body
	
	var speed = body.velocity.y * motion_factor
	emit_signal("splash", index, speed)
	pass
	

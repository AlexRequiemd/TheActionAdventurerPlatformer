extends Node2D
var velocity = 3
onready var sprite = $sprite
onready var particle = $Particles2D
onready var light = $Light2D
func _ready():
	pass

func _process(delta):
	position.x += velocity
	_enable_light()
#	if velocity == velocity:
#		self.scale.x = 1
#		particle.process_material.gravity = Vector3(-98, 0, 0)
#	elif velocity == -velocity:
#		self.scale.x = -1
#		particle.process_material.gravity = Vector3(98, 0, 0)

func _enable_light():
	if get_parent().get_parent().is_in_group("dark_area"):
		light.enabled = true
	else:
		light.enabled = false

func destroy():
	velocity = 0
	particle.emitting = false
	sprite.play("destroy")

func _on_sprite_animation_finished():
	var anim = sprite.animation
	if anim == "destroy":
		self.queue_free()


func _on_Area2D_area_entered(area):
	destroy()


func _on_Area2D_body_entered(body):
	destroy()

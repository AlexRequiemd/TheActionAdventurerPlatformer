extends KinematicBody2D
var GRAVITY = 10
var JUMP_HEIGHT = 250
var velocity = Vector2.ZERO
var sfx_collect : AudioStream = load("res://Sounds/SFX/axilirate_collect_crystal.wav")


func _ready():
	velocity.y = -JUMP_HEIGHT/2

func _physics_process(delta):
	_gravity(delta)
	_move_and_slide()

func _gravity(_delta):
	velocity.y += GRAVITY
	
func _move_and_slide():
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_liferecover_area_area_entered(area):
	if area. name == "hurtbox":
		Global.hp += 10
		self.queue_free()

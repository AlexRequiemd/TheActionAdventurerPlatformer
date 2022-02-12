extends Node2D
onready var ge1 = $GroundEye_Boss
onready var ge2 = $GroundEye_Boss2
onready var ge3 = $GroundEye_Boss3
onready var ge4 = $GroundEye_Boss4
var groundeye_active = false
var atk = true
var destroy = false

func _ready():
	pass

func _process(delta):
	if groundeye_active == true:
		can_attack()
	if destroy == true:
		self.queue_free()
	if get_parent().dead == true:
		self.queue_free()

func can_attack():
	if atk == true:
		ge1._attack()
		ge2._attack()
		ge3._attack()
		ge4._attack()
		atk = false
	else:
		pass

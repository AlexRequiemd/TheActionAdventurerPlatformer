extends KinematicBody2D
onready var raycast1 = $RayCast1
onready var raycast2 = $RayCast2
onready var sprite = $sprite
onready var input = $Input
onready var dialogue_gui = $Dialogue_System/Dialogue_Box
var dialog_can_show = false

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up") and (dialog_can_show == true):
		emit_signal("force_idle")
		Global.dialogue_happen = true
		dialogue_gui.show()
		
	if raycast1.is_colliding():
		sprite.flip_h = false
	elif raycast2.is_colliding():
		sprite.flip_h = true




func _on_dialogue_area_body_entered(body):
	if body.name == "Player":
		dialog_can_show = true
		input.show()


func _on_dialogue_area_body_exited(body):
	if body.name == "Player":
		dialog_can_show = false
		input.hide()

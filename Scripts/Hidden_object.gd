extends Node2D
onready var tween = $Tween
export var minimum_alpha = 0

func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
			tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, minimum_alpha), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
		
	


func _on_Area2D_body_exited(body):
	if body.name == "Player":
			tween.interpolate_property(self, "modulate", Color(1, 1, 1, minimum_alpha), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
		

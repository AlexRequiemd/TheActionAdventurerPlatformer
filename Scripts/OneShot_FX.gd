extends Node2D
onready var sprite = $sprite
var guard = false

func _ready():
	if get_parent().name == "Player":
		if get_parent().current_state == get_parent().DEFENSE:
			guard = true
	
	if guard == false:
		sprite.play("hit")
	if guard == true:
		sprite.play("guard")


func _on_sprite_animation_finished():
	self.queue_free()

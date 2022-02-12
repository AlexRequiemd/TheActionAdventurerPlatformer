extends Node2D


func _ready():
	pass

func _process(delta):
	if get_parent().dead == true:
		self.queue_free()

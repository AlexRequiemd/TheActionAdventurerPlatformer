extends Node2D
export var cell_id = 0

func _ready():
	pass


func _on_Cell_area_body_entered(body):
	if body.name == "Player":
		get_parent().cell_id = cell_id

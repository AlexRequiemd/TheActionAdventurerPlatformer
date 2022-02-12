extends Node2D
onready var camera = $Camera2D

func _ready():
	
	var tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_node("TileMap").cell_size
	camera.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	camera.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	camera.limit_top = tilemap_rect.position.y * tilemap_cell_size.y
	camera.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y

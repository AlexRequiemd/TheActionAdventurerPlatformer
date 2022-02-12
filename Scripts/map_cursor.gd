extends Node2D
var velocity = 8
onready var texture = $texture

func _ready():
	pass

func _physics_process(delta):
	set_cell_position()
	if texture.modulate.a <= 0:
		texture.modulate.a = 1

func set_cell_position():
	
	if Global.current_cell == 0:
		position = Vector2(20, 60)
	elif Global.current_cell == 1:
		position = Vector2(28, 60)
	elif Global.current_cell == 2:
		position = Vector2(36, 60)
	elif Global.current_cell == 3:
		position = Vector2(44, 60)
	elif Global.current_cell == 4:
		position = Vector2(52, 60)
	elif Global.current_cell == 5:
		position = Vector2(20, 68)
	elif Global.current_cell == 6:
		position = Vector2(28, 68)
	elif Global.current_cell == 7:
		position = Vector2(36, 68)
	elif Global.current_cell == 8:
		position = Vector2(44, 68)
	elif Global.current_cell == 9:
		position = Vector2(52, 68)
	elif Global.current_cell == 10:
		position = Vector2(44, 76)
	elif Global.current_cell == 11:
		position = Vector2(44, 84)
	elif Global.current_cell == 12:
		position = Vector2(68, 60)
	elif Global.current_cell == 13:
		position = Vector2(60, 68)
	elif Global.current_cell == 14:
		position = Vector2(68, 68)
	elif Global.current_cell == 15:
		position = Vector2(76, 68)
	elif Global.current_cell == 16:
		position = Vector2(84, 68)
	elif Global.current_cell == 17:
		position = Vector2(60, 76)
	elif Global.current_cell == 18:
		position = Vector2(92, 68)
	elif Global.current_cell == 19:
		position = Vector2(60, 60)
	elif Global.current_cell == 20:
		position = Vector2(100, 68)
	elif Global.current_cell == 21:
		position = Vector2(108, 68)
	elif Global.current_cell == 22:
		position = Vector2(108, 76)
	
#WORLD1
#id 0 = 20, 60
#id 1 = 28, 60
#id 2 = 36, 60
#id 3 = 44, 60
#id 4 = 52, 60
#id 5 = 20, 68
#id 6 = 28, 68
#id 7 = 36, 68
#id 8 = 44, 68
#id 9 = 52, 68
#id 10 = 44, 76
#id 11 = 44, 84
#WORLD2
#id 12 = 68, 60
#id 13 = 60, 68
#id 14 = 68, 68
#id 15 = 76, 68
#id 16 = 84, 68
#id 17 = 60, 76
#WORLD_SAVEPOINT1
#id 10 = 92, 68

func _on_Timer_timeout():
	texture.modulate.a -= 0.05

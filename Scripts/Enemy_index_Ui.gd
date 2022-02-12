extends CanvasLayer
var enemy_node
var enemy_name = " "
var index = " "
var current_enemy = null

onready var enemy_ui = $Enemy_Ui
onready var label = $Enemy_Ui/Panel/Label
onready var timer = $E_Ui_timer

func _ready():
	label.text = " "


func _process(delta):
	index()
	find_enemynode(delta)
	

func get_name():
	label.text = enemy_name
	enemy_ui.show()
	timer.start()
	

func index():
#	if get_tree().get_root().find_node("Slime", true, false):
#		index = "Slime"
#	elif get_tree().get_root().find_node("Skeleton", true, false):
#		index = "Skeleton"
#	elif get_tree().get_root().find_node("Flying_Eye", true, false):
#		index = "Flying_Eye"
#	elif get_tree().get_root().find_node("Dark_Eye", true, false):
#		index = "Dark_Eye"
#	else: index = " "
	if Global.current_enemy == 0:
		if get_tree().get_root().find_node("Slime", true, false):
			index = "Slime"
			enemy_name = "Slime"
		else:
			index = " "
			enemy_name = " "
	if Global.current_enemy == 1:
		if get_tree().get_root().find_node("Skeleton", true, false):
			index = "Skeleton"
			enemy_name = "Skeleton"
		else:
			index = " "
			enemy_name = " "
	if Global.current_enemy == 2:
		if get_tree().get_root().find_node("Flying_Eye", true, false):
			index = "Flying_Eye"
			enemy_name = "Flying Eye"
		else:
			index = " "
			enemy_name = " "
	if Global.current_enemy == 3:
		if get_tree().get_root().find_node("Dark_Eye", true, false):
			index = "Dark_Eye"
			enemy_name = "Dark Eye"
		else:
			index = " "
			enemy_name = " "
	if Global.current_enemy == 4:
		if get_tree().get_root().find_node("Mushroom", true, false):
			index = "Mushroom"
			enemy_name = "Mushroom"
		else:
			index = " "
			enemy_name = " "
	if Global.current_enemy == null:
		index = " "
		enemy_name = " "

func find_enemynode(Name):
	if index != " ":
		Name = index
		enemy_node = get_tree().get_root().find_node(Name, true, false)
		get_name()
		if enemy_node == null:
			pass
	else: pass
	


func _on_E_Ui_timer_timeout():
	enemy_ui.hide()
	Global.current_enemy = null
#	enemy_node.disconnect("e_damaged", self, "get_name")




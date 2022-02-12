extends Control
var index
var cel_target
var cell_data = {
		"cel_0" : true,
		"cel_1" : true,
		"cel_2" : true,
		"cel_3" : true,
		"cel_4" : true,
		"cel_5" : true,
		"cel_6" : true,
		"cel_7" : true,
		"cel_8" : true,
		"cel_9" : true,
		"cel_10" : true,
		"cel_11" : true,
		"cel_12" : true,
		"cel_13" : true,
		"cel_14" : true,
		"cel_15" : true,
		"cel_16" : true,
		"cel_17" : true,
		"cel_18" : true,
		"cel_19" : true,
		"cel_20" : true,
		"cel_21" : true,
		"cel_22" : true,
	}

func _ready():
	cell_data = Global.cell_data

func _process(delta):
	set_cel_visibility()
	global_data_to_cel()
	

func set_cel_visibility():
	index = Global.current_cell
	cel_target = String("cel_" + str(index))
	get_child(int(cel_target)).visible = false
	save_cel_visibility()
	set_global_cel()
#	print("cel_target: ", cel_target)

func global_data_to_cel():
	if Global.cell_data.cel_0 == false:
		get_node("cel_0").visible = false
	if Global.cell_data.cel_1 == false:
		get_node("cel_1").visible = false
	if Global.cell_data.cel_2 == false:
		get_node("cel_2").visible = false
	if Global.cell_data.cel_3 == false:
		get_node("cel_3").visible = false
	if Global.cell_data.cel_4 == false:
		get_node("cel_4").visible = false
	if Global.cell_data.cel_5 == false:
		get_node("cel_5").visible = false
	if Global.cell_data.cel_6 == false:
		get_node("cel_6").visible = false
	if Global.cell_data.cel_7 == false:
		get_node("cel_7").visible = false
	if Global.cell_data.cel_8 == false:
		get_node("cel_8").visible = false
	if Global.cell_data.cel_9 == false:
		get_node("cel_9").visible = false
	if Global.cell_data.cel_10 == false:
		get_node("cel_10").visible = false
	if Global.cell_data.cel_11 == false:
		get_node("cel_11").visible = false
	if Global.cell_data.cel_12 == false:
		get_node("cel_12").visible = false
	if Global.cell_data.cel_13 == false:
		get_node("cel_13").visible = false
	if Global.cell_data.cel_14 == false:
		get_node("cel_14").visible = false
	if Global.cell_data.cel_15 == false:
		get_node("cel_15").visible = false
	if Global.cell_data.cel_16 == false:
		get_node("cel_16").visible = false
	if Global.cell_data.cel_17 == false:
		get_node("cel_17").visible = false
	if Global.cell_data.cel_18 == false:
		get_node("cel_18").visible = false
	if Global.cell_data.cel_19 == false:
		get_node("cel_19").visible = false
	if Global.cell_data.cel_20 == false:
		get_node("cel_20").visible = false
	if Global.cell_data.cel_21 == false:
		get_node("cel_21").visible = false
	if Global.cell_data.cel_22 == false:
		get_node("cel_22").visible = false

func save_cel_visibility():
	if get_node("cel_0").visible == false:
		cell_data.cel_0 = false
	if get_node("cel_1").visible == false:
		cell_data.cel_1 = false
	if get_node("cel_2").visible == false:
		cell_data.cel_2 = false
	if get_node("cel_3").visible == false:
		cell_data.cel_3 = false
	if get_node("cel_4").visible == false:
		cell_data.cel_4 = false
	if get_node("cel_5").visible == false:
		cell_data.cel_5 = false
	if get_node("cel_6").visible == false:
		cell_data.cel_6 = false
	if get_node("cel_7").visible == false:
		cell_data.cel_7 = false
	if get_node("cel_8").visible == false:
		cell_data.cel_8 = false
	if get_node("cel_9").visible == false:
		cell_data.cel_9 = false
	if get_node("cel_10").visible == false:
		cell_data.cel_10 = false
	if get_node("cel_11").visible == false:
		cell_data.cel_11 = false
	if get_node("cel_12").visible == false:
		cell_data.cel_12 = false
	if get_node("cel_13").visible == false:
		cell_data.cel_13 = false
	if get_node("cel_14").visible == false:
		cell_data.cel_14 = false
	if get_node("cel_15").visible == false:
		cell_data.cel_15 = false
	if get_node("cel_16").visible == false:
		cell_data.cel_16 = false
	if get_node("cel_17").visible == false:
		cell_data.cel_17 = false
	if get_node("cel_18").visible == false:
		cell_data.cel_18 = false
	if get_node("cel_19").visible == false:
		cell_data.cel_19 = false
	if get_node("cel_20").visible == false:
		cell_data.cel_20 = false
	if get_node("cel_21").visible == false:
		cell_data.cel_21 = false
	if get_node("cel_22").visible == false:
		cell_data.cel_22 = false

func set_global_cel():
	Global.cell_data = cell_data

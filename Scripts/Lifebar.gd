extends TextureProgress
onready var life = $Life
onready var mana = $Mana
onready var hp_delay = $L_Delay
onready var mp_delay = $M_Delay
onready var timer = $Timer
var player_node = null

func _ready():
	
	player_node = get_tree().get_root().find_node("Player", true, false)
	hp_delay.value = Global.hp
	player_node.connect("damaged", self, "on_damaged")
	player_node.connect("cast", self, "on_cast")
	

func _physics_process(delta):
	life.value = Global.hp
	life.max_value = Global.max_hp
	mana.value = Global.mp
	mana.max_value = Global.max_mp
	hp_delay.max_value = Global.max_hp
	mp_delay.max_value = Global.max_mp
	if hp_delay.value < Global.hp:
		hp_delay.value = Global.hp
	if mp_delay.value < Global.mp:
		mp_delay.value = Global.mp

	
	
	
func on_damaged():
	timer.start()

func on_cast():
	timer.start()

func _on_Timer_timeout():
	if hp_delay.value > Global.hp:
		hp_delay.value -= 1
	if mp_delay.value > Global.mp:
		mp_delay.value -= 1

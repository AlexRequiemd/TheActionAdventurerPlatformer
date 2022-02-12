extends CanvasLayer
onready var life = $Lifebar/Life
onready var hp_delay = $Lifebar/L_Delay
onready var timer = $Lifebar/Timer

func _ready():
	
#	player_node = get_tree().get_root().find_node("Player", true, false)
	hp_delay.value = get_parent().hp
	get_parent().connect("boss_damaged", self, "on_damaged")
	

func _physics_process(delta):
	life.value = get_parent().hp
	life.max_value = get_parent().hp_max
	hp_delay.max_value = get_parent().hp_max
	if hp_delay.value < get_parent().hp:
		hp_delay.value = get_parent().hp

func _disconnect():
	get_parent().disconnect("boss_damaged", self, "on_damaged")

func on_damaged():
	timer.start()

func _on_Timer_timeout():
	if hp_delay.value > get_parent().hp:
		hp_delay.value -= 4

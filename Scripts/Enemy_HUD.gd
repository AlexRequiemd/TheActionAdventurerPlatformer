extends Control
onready var delay = $e_delay
onready var timer = $delay_timer

func _ready():
	delay.value = get_parent().hp
	get_parent().connect("e_damaged", self, "on_damaged")

func _physics_process(delta):
	delay.max_value = get_parent().hp_max
	if delay.value < get_parent().hp:
		delay.value = get_parent().hp

func on_damaged():
	timer.start()


func _on_delay_timer_timeout():
	if delay.value > get_parent().hp:
		delay.value -= 1

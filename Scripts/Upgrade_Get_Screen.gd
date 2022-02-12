extends CanvasLayer
onready var sprite = $Get_Upgrade/Sprite
onready var upgrade_gui = $Get_Upgrade
onready var text = $Get_Upgrade/text
onready var timer = $Timer
var current_upgrade = 0
#0 = LifeUp, 1 = ManaUp, 
#2 = SlideBoots, 3 = DoubleBoots, 4 = SpeedScarf, 
#5 = FlameGauntlet, 6 = RedSword, 7 = BestShield
var panel_lifeup = load("res://Assets/UI/upgrade_get/get_upgrade_LIFEUP.png")
var panel_manaup = load("res://Assets/UI/upgrade_get/get_upgrade_MANAUP.png")
var panel_slideboots = load("res://Assets/UI/upgrade_get/get_upgrade_SLIDEBOOTS.png")
var panel_doubleboots = load("res://Assets/UI/upgrade_get/get_upgrade_DOUBLEBOOTS.png")
var panel_speedscarf = load("res://Assets/UI/upgrade_get/get_upgrade_SPEEDSCARF.png")
var panel_flamegauntlet = load("res://Assets/UI/upgrade_get/get_upgrade_FIREGAUNTLET.png")
var panel_redsword = load("res://Assets/UI/upgrade_get/get_upgrade_REDSWORD.png")
var panel_bestshield = load("res://Assets/UI/upgrade_get/get_upgrade_BESTSHIELD.png")

func _ready():
	pass

func _process(delta):
	set_panel()

func set_panel():
	if current_upgrade == 0:
		sprite.texture = panel_lifeup
		text.text = "Max Health has increased"
	elif current_upgrade == 1:
		sprite.texture = panel_manaup
		text.text = "Max Mana has increased"
	elif current_upgrade == 2:
		text.text = "Press DOWN+JUMP to Slide"
		sprite.texture = panel_slideboots
	elif current_upgrade == 3:
		text.text = "Press JUMP while in the air to do a Double Jump"
		sprite.texture = panel_doubleboots
	elif current_upgrade == 4:
		text.text = "Hold DASH+LEFT/RIGHT to Rush"
		sprite.texture = panel_speedscarf
	elif current_upgrade == 5:
		text.text = "Press SPECIAL to cast a Fireball"
		sprite.texture = panel_flamegauntlet
	elif current_upgrade == 6:
		text.text = "Sword Attack Power has increased"
		sprite.texture = panel_redsword
	elif current_upgrade == 7:
		text.text = "Shield nullifies any physical attack"
		sprite.texture = panel_bestshield


func _on_Get_Upgrade_visibility_changed():
	if upgrade_gui.visible == true:
		timer.start()
	else: pass


func _on_Timer_timeout():
	upgrade_gui.visible = false
	get_tree().paused = false

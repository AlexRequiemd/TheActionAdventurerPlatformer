extends Node
var bg_music : AudioStream = load("res://Sounds/BGM/slaking-97 - Fairy Tale Harps Chime.wav")
var failed_music : AudioStream = load("res://Sounds/BGM/Narutimate_Accel_2 - Wish... Dance on the Clouds_short.wav")
var sfx_upgrade : AudioStream = load("res://Sounds/SFX/sheyvan_victory_fanfare.wav")
onready var audio_manager = $audio_manager
onready var upgrade_screen = $Upgrade_Get_Screen
onready var upgrade_gui = $Upgrade_Get_Screen/Get_Upgrade
var cell_id

func _ready():
	yield(get_tree().create_timer(.5), "timeout")
	audio_manager.play_music(bg_music)

func _process(delta):
	Global.current_cell = cell_id


func failed():
	$UI.failed()
	audio_manager.play_music(failed_music)

#UPGRADE HAS COLLLIDED------------------------------------------------------------------------------
func _on_item_LifeUP_area_area_entered(area):
	if area.name == "hurtbox":
		get_tree().paused = true
		audio_manager.play_sfx(sfx_upgrade)
		upgrade_screen.current_upgrade = 0
		upgrade_gui.visible = true
	else: pass

func _on_item_ManaUp_area_area_entered(area):
	if area.name == "hurtbox":
		get_tree().paused = true
		audio_manager.play_sfx(sfx_upgrade)
		upgrade_screen.current_upgrade = 1
		upgrade_gui.visible = true
	else: pass

func _on_item_RedSword_area_area_entered(area):
	if area.name == "hurtbox":
		get_tree().paused = true
		audio_manager.play_sfx(sfx_upgrade)
		upgrade_screen.current_upgrade = 6
		upgrade_gui.visible = true
	else: pass

func _on_item_BestShield_area_area_entered(area):
	if area.name == "hurtbox":
		get_tree().paused = true
		audio_manager.play_sfx(sfx_upgrade)
		upgrade_screen.current_upgrade = 7
		upgrade_gui.visible = true
	else: pass

func _on_item_SlideBoots_area_area_entered(area):
	if area.name == "hurtbox":
		get_tree().paused = true
		audio_manager.play_sfx(sfx_upgrade)
		upgrade_screen.current_upgrade = 2
		upgrade_gui.visible = true
	else: pass

func _on_item_SpeedScarf_area_area_entered(area):
	if area.name == "hurtbox":
		get_tree().paused = true
		audio_manager.play_sfx(sfx_upgrade)
		upgrade_screen.current_upgrade = 4
		upgrade_gui.visible = true
	else: pass

func _on_item_DoubleBoots_area_area_entered(area):
	if area.name == "hurtbox":
		get_tree().paused = true
		audio_manager.play_sfx(sfx_upgrade)
		upgrade_screen.current_upgrade = 3
		upgrade_gui.visible = true
	else: pass

func _on_item_FlameGauntlet_area_area_entered(area):
	if area.name == "hurtbox":
		get_tree().paused = true
		audio_manager.play_sfx(sfx_upgrade)
		upgrade_screen.current_upgrade = 5
		upgrade_gui.visible = true
	else: pass

extends Control
onready var music_slider = $Slider_group/VBoxContainer/Slider_M/slider_bgm
onready var sound_slider = $Slider_group/VBoxContainer/Slider_S/slider_sfx
onready var audio_manager = $audio_manager
var sfx_cursor : AudioStream = load("res://Sounds/SFX/ui_cursor.wav")
var sfx_accept : AudioStream = load("res://Sounds/SFX/ui_accept.wav")
var sfx_cancel : AudioStream = load("res://Sounds/SFX/ui_cancel.wav")
var audio = {music_disabled = false, fx_disabled = false, music_volume = 0, fx_volume = 0}

func _ready():
	music_slider.value = Global.audio.music_volume
	sound_slider.value = Global.audio.fx_volume

func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		self.hide()

func _on_slider_bgm_mouse_exited():
	music_slider.release_focus()


func _on_slider_sfx_mouse_exited():
	sound_slider.release_focus()


func _on_slider_bgm_value_changed(value):
	audio.music_volume = value
	AudioServer.set_bus_volume_db(1, lerp(AudioServer.get_bus_volume_db(1), value, 0.5))
	if value == -20:
		audio.music_disabled = true
		AudioServer.set_bus_mute(1, true)
	else:
		audio.music_disabled = false
		AudioServer.set_bus_mute(1, false)


func _on_slider_sfx_value_changed(value):
	audio_manager.play_sfx(sfx_cursor)
	audio.fx_volume = value
	AudioServer.set_bus_volume_db(2, lerp(AudioServer.get_bus_volume_db(2), value, 0.5))
	if value == -20:
		audio.fx_disabled = true
		AudioServer.set_bus_mute(2, true)
	else:
		audio.fx_disabled = false
		AudioServer.set_bus_mute(2, false)


func _on_nosave_button_pressed():
	music_slider.value = Global.audio.music_volume
	sound_slider.value = Global.audio.fx_volume

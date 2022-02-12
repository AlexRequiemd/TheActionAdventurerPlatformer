extends Control
export(String, FILE, "*.json") var Dialogue_File
export var last_dialog = 0
onready var text = $RichTextLabel
onready var char_name = $RichTextLabel2
onready var tween = $Tween
onready var next_icon = $icon
var dialog = []
#var dialog = [
#	" Hello Generic Adventurer! How is going?",
#	" ....",
#	" Erm... Silent like always huh?",
#	" Well, see ya around!"
#]
var dialog_index = 0
var finished = false
var speaked = false

func _ready():
	yield(get_tree().create_timer(.5), "timeout")
	set_dialogfile()
	play_dialog()

func _process(delta):
	next_icon.visible = finished
	if Input.is_action_just_pressed("ui_accept") and finished == true:
		play_dialog()

func set_dialogfile():
	dialog = load_dialog()

func load_dialog():
	var file = File.new()
	if file.file_exists(Dialogue_File):
		file.open(Dialogue_File, file.READ)
		return parse_json(file.get_as_text())

func play_dialog():
	if speaked == true:
		if dialog_index < dialog.size():
			finished = false
			char_name.bbcode_text = dialog[last_dialog]["name"]
			text.bbcode_text = dialog[last_dialog]["text"]
			text.percent_visible = 0
			tween.interpolate_property(text, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
		elif dialog_index > dialog.size():
			self.visible = false
			speaked = true
			Global.dialogue_happen = false
			emit_signal("force_idle")
	else:
		if dialog_index < dialog.size():
			finished = false
			char_name.bbcode_text = dialog[dialog_index]["name"]
			text.bbcode_text = dialog[dialog_index]["text"]
			text.percent_visible = 0
			tween.interpolate_property(text, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
		elif dialog_index > dialog.size():
			self.visible = false
			speaked = true
			Global.dialogue_happen = false
			emit_signal("force_idle")
	dialog_index += 1


func _on_Tween_tween_completed(object, key):
	finished = true
	

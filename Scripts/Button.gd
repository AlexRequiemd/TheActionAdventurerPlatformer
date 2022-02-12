extends TextureButton
onready var text = $text

func _ready():
	pass


func _process(delta):
	print(pressed)


func _on_Button_pressed():
	text.modulate.r = text.modulate.r/2
	text.modulate.g = text.modulate.g/2
	text.modulate.b = text.modulate.b/2


func _on_Button_focus_entered():
	text.modulate.r = 100
	text.modulate.g = 100
	text.modulate.b = 100
	


func _on_Button_focus_exited():
	text.modulate.r = text.modulate.r/2
	text.modulate.g = text.modulate.g/2
	text.modulate.b = text.modulate.b/2


func _on_Button_mouse_entered():
	text.modulate.r = 100
	text.modulate.g = 100
	text.modulate.b = 100


func _on_Button_mouse_exited():
	text.modulate.r = text.modulate.r/2
	text.modulate.g = text.modulate.g/2
	text.modulate.b = text.modulate.b/2

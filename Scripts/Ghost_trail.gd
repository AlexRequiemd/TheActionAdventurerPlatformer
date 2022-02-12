extends Sprite
onready var tween = $alpha_tween

func _ready():
	tween.interpolate_property(self, "modulate", Color(0, 0.952941, 1, 1), Color(0, 0.952941, 1, 0), .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()


func _on_alpha_tween_tween_completed(object, key):
	queue_free()

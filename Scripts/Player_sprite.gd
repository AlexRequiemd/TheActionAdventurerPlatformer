extends AnimatedSprite


func _ready():
	pass

func _process(delta):
	material.set("shader_param/NEW_COLOR1", Color(0.85098, 0.341176, 0.388235, 1))
	material.set("shader_param/NEW_COLOR2", Color(0.670588, 0.262745, 0.262745, 1))
	material.set("shader_param/NEW_COLOR3", Color(0.560784, 0.196078, 0.196078, 1))

func change_color():
	
	if Global.upgrades.rush == true:
		material.set("shader_param/NEW_COLOR1", Color(0.290196, 0.901961, 0.768627, 1))
		material.set("shader_param/NEW_COLOR2", Color(0.219608, 0.709804, 0.65098, 1))
		material.set("shader_param/NEW_COLOR3", Color(0.156863, 0.596078, 0.541176, 1))

	elif Global.upgrades.rush == false:
		material.set("shader_param/NEW_COLOR1", Color(0.85098, 0.341176, 0.388235, 1))
		material.set("shader_param/NEW_COLOR2", Color(0.670588, 0.262745, 0.262745, 1))
		material.set("shader_param/NEW_COLOR3", Color(0.560784, 0.196078, 0.196078, 1))
	pass

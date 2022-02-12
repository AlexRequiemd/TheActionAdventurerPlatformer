extends Node
var bg_music : AudioStream = load("res://Sounds/BGM/slaking-97 - Fairy Tale Harps Chime.wav")
var failed_music : AudioStream = load("res://Sounds/BGM/Narutimate_Accel_2 - Wish... Dance on the Clouds_short.wav")
onready var audio_manager = $audio_manager
onready var hit_fx = preload("res://Prefabs/fx_hit.tscn")
onready var player = $Player
var cell_id


func _ready():
	
	yield(get_tree().create_timer(.5), "timeout")
	audio_manager.play_music(bg_music)
#	player.connect("damaged", self, "instance_hit")

func _process(delta):
	Global.current_cell = cell_id
#	print("Global_cell_id: ", Global.current_cell)

func failed():
	$UI.failed()
	audio_manager.play_music(failed_music)


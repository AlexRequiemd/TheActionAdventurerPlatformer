extends Node2D

export var k = 0.015
export var d = 0.03
export var spread = 0.0002
export var distance_between_springs = 16
export var spring_number = 0
export var depth = 1000
export var border_thickness = 1.0
export var water_influence = true

var springs = []
var passes = 8
var target_height = global_position.y
var bottom = target_height + depth

var sfx_splash1 : AudioStream = load("res://Sounds/SFX/Michel Baradari - splash2.wav")
var sfx_splash2 : AudioStream = load("res://Sounds/SFX/Michel Baradari - splash1.wav")


onready var water_spring = preload("res://Prefabs/Water_spring.tscn")
onready var water_polygon = $water_polygon
onready var water_border = $water_border
onready var collisionShape = $water_body_area/CollisionShape2D
onready var water_body_area = $water_body_area
onready var audio_manager = $audio_manager
onready var splash_particle = preload("res://Prefabs/splash_particles.tscn")

func _ready():
	water_border.width = border_thickness
	
	spread = spread / 1000
	
	for i in range(spring_number):
		var x_position = distance_between_springs * i
		var w = water_spring.instance()
		add_child(w)
		springs.append(w)
		w.initialize(x_position, i)
		w.set_collision_width(distance_between_springs)
		w.connect("splash", self, "splash")
	
	splash(2,5)
	
	var total_lenght = distance_between_springs * (spring_number - 1)
	var rectangle = RectangleShape2D.new().duplicate()
	var rect_position = Vector2(total_lenght/2, depth/2)
	var rect_extents = Vector2(total_lenght/2, depth/2)
	
	water_body_area.position = rect_position
	rectangle.set_extents(rect_extents)
	collisionShape.set_shape(rectangle)

func _physics_process(delta):
	for i in springs:
		i.water_update(k, d)
	
	var left_deltas = []
	var right_deltas = []
	
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for j in range(passes):
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
				
			if i < springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	new_border()
	draw_water_body()

func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed

func draw_water_body():
	var curve = water_border.curve
	var points = Array(curve.get_baked_points())
	var water_polygon_points = points
		
	var first_index = 0
	var last_index = water_polygon_points.size()-1
	
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, bottom))
	
	water_polygon_points = PoolVector2Array(water_polygon_points)
	
	water_polygon.set_polygon(water_polygon_points)

func new_border():
	var curve = Curve2D.new().duplicate()
	var surface_points = []
	
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
	
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
	
	water_border.curve = curve
	water_border.smooth(true)
	water_border.update()

func _on_water_body_area_body_entered(body):
	var splash = splash_particle.instance()
	audio_manager.play_sfx(sfx_splash1)
	if body.name == "Player" and water_influence == true:
		body.GRAVITY = 10/5
		body.JUMP_HEIGHT = 250/2
		body.MAX_SPEED = 100/1.5
		body.ACCEL = 50/2
		body.WALL_SLIDE_ACCEL = 10/2
		body.WALL_SLIDE_MAX_SPEED = 40/2
		if body.velocity.y >= 0 and body.current_state != body.WALL_SLIDE:
			body.velocity.y = min(body.velocity.y+body.GRAVITY/5, body.GRAVITY/5)
		
	#adds the particle to the scene
	if body.current_state != body.D_JUMP:
		get_tree().current_scene.add_child(splash)
	#sets the position of the particle to the same of the body
	splash.global_position.x = body.global_position.x
	splash.global_position.y = body.global_position.y+32

func _on_water_body_area_body_exited(body):
	var splash = splash_particle.instance()
	audio_manager.play_sfx(sfx_splash2)
	if body.name == "Player" and water_influence == true:
		body.GRAVITY = 10
		body.JUMP_HEIGHT = 250
		body.MAX_SPEED = 100
		body.ACCEL = 50
		body.WALL_SLIDE_ACCEL = 10
		body.WALL_SLIDE_MAX_SPEED = 40
	
	#adds the particle to the scene
	if body.current_state != body.D_JUMP:
		get_tree().current_scene.add_child(splash)
	#sets the position of the particle to the same of the body
	splash.global_position.x = body.global_position.x
	splash.global_position.y = body.global_position.y+32

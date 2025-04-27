extends Node2D

@export var platform_scene : PackedScene
@export var small_grass_scene : PackedScene
@export var medium_grass_scene : PackedScene
@export var large_grass_scene : PackedScene
@export var small_ice_scene : PackedScene
@export var medium_ice_scene : PackedScene
@export var large_ice_scene : PackedScene

@export var spawn_range_x : Vector2 = Vector2(100, 540)
@export var spawn_distance_y : float = 150.0
@export var max_x_distance : float = 400.0
@export var min_x_distance : float = 150.0
@export var player : NodePath
@export var platform_margin_below : float = 300.0 # kamera altında ne kadar kalınca silinsin

var last_spawn_y = 350
var last_spawn_x = 320
var platforms = [] # oluşturulan platformları tutuyoruz
var scenes = []

var random_num

var platform_counter : int

var index_begin : int
var index_last : int

var change_platform : bool

func _ready():
	scenes.append(small_grass_scene)
	scenes.append(medium_grass_scene)
	scenes.append(large_grass_scene)
	scenes.append(small_ice_scene)
	scenes.append(medium_ice_scene)
	scenes.append(large_ice_scene)
	platform_counter = 0
	index_begin = 0
	index_last = 2
	change_platform = false

func _process(delta):
	var player_node = get_node(player)
	var player_y = player_node.global_position.y
	
	# Sonsuz üretim: üstte yeni platform oluştur
	while last_spawn_y > player_y - 500:
		spawn_platform()

	# Altında kalan platformları bul
	var to_remove = []
	for platform in platforms:
		if is_instance_valid(platform) and platform.global_position.y > player_y + platform_margin_below:
			to_remove.append(platform)
	
	# Sonra temizle
	for platform in to_remove:
		platforms.erase(platform)
		platform.queue_free()
	
	if !change_platform:
		check_platform_num()
		index_begin = 3
		index_last = 5

func spawn_platform():
	random_num = randi_range(index_begin, index_last)
	var platform = scenes[random_num].instantiate()
	platform_counter += 1
	add_child(platform)
	platforms.append(platform)

	var x = last_spawn_x
	while x == last_spawn_x:
		var direction = -1 if randf() < 0.5 else 1
		var distance = randf_range(min_x_distance, max_x_distance)
		x = last_spawn_x + direction * distance
		x = clamp(x, spawn_range_x.x, spawn_range_x.y)

	var y = last_spawn_y - spawn_distance_y

	platform.position = Vector2(x, y)

	last_spawn_y = y
	last_spawn_x = x
	print(random_num)

func check_platform_num():
	if platform_counter >= 10:
		change_platform = true
		return true

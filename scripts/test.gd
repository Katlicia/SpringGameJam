extends Node2D

@export var platform_scene : PackedScene
@export var spawn_range_x : Vector2 = Vector2(100, 540)
@export var spawn_distance_y : float = 150.0
@export var max_x_distance : float = 400.0
@export var min_x_distance : float = 150.0
@export var player : NodePath
@export var platform_margin_below : float = 300.0 # kamera altında ne kadar kalınca silinsin

var last_spawn_y = 350
var last_spawn_x = 320
var platforms = [] # oluşturulan platformları tutuyoruz

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

func spawn_platform():
	var platform = platform_scene.instantiate()
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

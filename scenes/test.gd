extends Node2D

@export var platform_scene: PackedScene
@export var player: CharacterBody2D

var last_spawn_x = 0

func _ready():
	last_spawn_x = player.global_position.x + 400 # Başlangıçta ileri spawnlasın

func _process(delta):
	if player.global_position.x > last_spawn_x - 300:
		spawn_platform()

func spawn_platform():
	var platform = platform_scene.instantiate()
	add_child(platform)

	var random_y = randf_range(-200, 200) # Yüksekliği biraz rastgele
	var distance_x = randf_range(250, 400) # Platformlar arası mesafe

	platform.global_position = Vector2(last_spawn_x + distance_x, random_y + 400) # 400 Y yere göre ayarladım
	last_spawn_x = platform.global_position.x

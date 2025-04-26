extends Area2D

var fixed_x_position = 0.0
@export var target: CharacterBody2D

func _ready():
	fixed_x_position = global_position.x

func _process(delta):
	global_position.x = fixed_x_position # X sabit
	global_position.y = target.global_position.y + 100
	#print(global_position.y)

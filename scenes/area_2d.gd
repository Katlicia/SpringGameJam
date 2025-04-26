extends Area2D

var fixed_x_position = 0.0
var y_position

func _ready():
	fixed_x_position = global_position.x

func _process(delta):
	y_position = get_viewport().get_visible_rect().size[1]
	global_position.x = fixed_x_position # X sabit
	global_position.y = y_position # Y, hedefi takip ediyor
	#print(global_position.y)

extends Camera2D

@export var target: Node2D # Takip edeceği hedef (mesela Player)

var fixed_x_position = 320
var camera_offset = 300
var res

func _ready():
	fixed_x_position = 320
	res = get_viewport().get_visible_rect().size

func _process(delta):
	if target:
		global_position.x = fixed_x_position # X sabit
		if target.global_position.y:
			global_position.y = target.global_position.y # Y, hedefi takip ediyor
		#print(global_position.y)

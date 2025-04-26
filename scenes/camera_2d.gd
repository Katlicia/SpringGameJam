extends Camera2D

@export var target: Node2D # Takip edeceği hedef (mesela Player)

var fixed_x_position = 0.0

func _ready():
	fixed_x_position = global_position.x

func _process(delta):
	if target:
		global_position.x = fixed_x_position # X sabit
		global_position.y = target.global_position.y # Y, hedefi takip ediyor

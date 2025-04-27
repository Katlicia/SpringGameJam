extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0

@onready var sfx_frog: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var floor_ray_cast = $RayCast2D

@export var accelerationValue = 0.01
@export var slideValue = 0.01
@export var fullStopValue = 15

var pitch_randomiser

func _ready():
	$PlayerAnimation.play("idle")

func _process(delta: float):
	if $VisibleOnScreenNotifier2D.is_on_screen():
		pass

func _physics_process(delta: float) -> void:

	velocity.y += getGravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()
		pitch_randomiser = randf_range(0.90, 1.10)
		sfx_frog.pitch_scale = pitch_randomiser
		print(pitch_randomiser)
		sfx_frog.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if is_on_ice():
		_movement_on_ice(direction)
	else:
		_normal_movement(direction)

	move_and_slide()

func getGravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func jump():
	velocity.y = jump_velocity

func is_on_ice():
	var collider = floor_ray_cast.get_collider()
	if not collider: return false
	
	if collider.name == "SmallIce" or collider.name == "MediumIce" or collider.name == "LargeIce":
		return true

func _movement_on_ice(direction):
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, accelerationValue)
	else:
		velocity.x = lerp(velocity.x, 0.0, slideValue)
		if velocity.x < fullStopValue and velocity.x > -fullStopValue:
			velocity.x = 0

func _normal_movement(direction):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Player died")

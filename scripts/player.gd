extends CharacterBody2D


const SPEED = 260.0
const JUMP_VELOCITY = -700.0

@onready var sfx_frog: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_tree: AnimationTree = $AnimationTree

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
	##$PlayerAnimation.play("idle")
	animation_tree.active = true

func _process(delta: float):
	if !$VisibleOnScreenNotifier2D.is_on_screen():
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _physics_process(delta: float) -> void:

	if global_position.x > 620:
		global_position.x = 620

	velocity.y += getGravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		pitch_randomiser = randf_range(0.90, 1.10)
		sfx_frog.pitch_scale = pitch_randomiser
		sfx_frog.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if is_on_ice():
		_movement_on_ice(direction)
	else:
		_normal_movement(direction)
	var input_x = Input.get_axis("left", "right")	
	if input_x < 0:
		input_x = -1
	elif input_x > 0:
		input_x = 1
	if input_x != 0:
		animation_tree.set("parameters/Jump/blend_position", input_x)
		animation_tree.set("parameters/Fall/blend_position", input_x)
	var velocity_y = velocity.y
	if velocity_y < 0:
		velocity_y = -1
	elif velocity_y > 0:
		velocity_y = 1
	else:
		pass
	if velocity_y == 1:
		animation_tree["parameters/playback"].travel("Fall")
	elif velocity_y == -1:
		animation_tree["parameters/playback"].travel("Jump")
	if is_on_floor():
		animation_tree["parameters/playback"].travel("Idle")
		
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
	pass

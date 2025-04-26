extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

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

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func getGravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func jump():
	velocity.y = jump_velocity

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Player died")

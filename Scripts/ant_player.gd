class_name Ant extends CharacterBody2D

@onready var down_ray : RayCast2D = %DownRayCast
@onready var ground_ray : RayCast2D = %GroundRayCast
@onready var jump_height_timer : Timer = %JumpHeightTimer
@onready var jump_buffer_timer : Timer = %JumpBufferTimer
@onready var coyote_timer : Timer = %CoyoteTimer

const SPEED = 250.0
const JUMP_VELOCITY = 500.0
const UP_GRAV = 980
const DOWN_GRAV = 1500

var ground_ray_contact : Vector2
var floor_angle : float = 0
var body_angle : float = 0
var buffered_jump : bool = false
var can_coyote_jump : bool = false


func _ready() -> void:
	Global.player = self


func _physics_process(delta: float) -> void:

	down_ray.global_rotation = 0
	ground_ray_contact = ground_ray.get_collision_point()

	# print("FLOOR ANGLE: ", rad_to_deg(floor_angle))
	# print("BODY ANGLE: ", rad_to_deg(body_angle))
	# print("NEW ANGLE: ", ground_ray_contact.direction_to(global_position))

	# Add the gravity.
	if not is_on_floor():
		if velocity.y <= 0:
			velocity += Vector2.DOWN * UP_GRAV * delta
		else:
			velocity += Vector2.DOWN * DOWN_GRAV * delta

	jump()

	# Handle slopes.
	if down_ray.get_collision_normal() and down_ray.is_colliding():
		floor_angle = atan(down_ray.get_collision_normal().y / down_ray.get_collision_normal().x) + deg_to_rad(90)
		if rad_to_deg(floor_angle) >= 90:
			body_angle = -(deg_to_rad(180) - floor_angle)
		else:
			body_angle = floor_angle
		global_rotation = lerp(global_rotation, body_angle, 15 * delta)
	else:
		body_angle = 0
		global_rotation = lerp(global_rotation, body_angle, 15 * delta)


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var was_on_floor : bool = is_on_floor()

	move_and_slide()
	handle_buffer_and_coyote(was_on_floor)


func jump(buffered : bool = false) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") or buffered:
		if is_on_floor() or can_coyote_jump:
			jump_height_timer.start()
			velocity.y = 0
			velocity += Vector2.UP * JUMP_VELOCITY
			if can_coyote_jump:
				can_coyote_jump = false
				print("COYOTE JUMP")
		else:
			buffered_jump = true
			jump_buffer_timer.start()


func handle_buffer_and_coyote(was_on_floor : bool) -> void:
	if not was_on_floor and is_on_floor():
		print("TOUCHED GROUND!")
		if buffered_jump:
			buffered_jump = false
			jump(true)
			print("BUFFER JUMP")
	elif was_on_floor and not is_on_floor() and velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()


func _on_jump_height_timer_timeout() -> void:
	if not Input.is_action_pressed("ui_accept"):
		if velocity.y < -100:
			velocity.y = -100


func _on_jump_buffer_timer_timeout() -> void:
	buffered_jump = false


func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false
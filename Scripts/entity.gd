class_name Entity extends CharacterBody2D

@export var collider : CollisionShape2D
@export var hurtbox : Area2D
@export var hitbox : Area2D
@export var down_ray : RayCast2D
@export var ground_ray : RayCast2D

@export var health : int
@export var damage : int
@export var speed : int
const UP_GRAV = 980
const DOWN_GRAV = 1500

var ground_ray_contact : Vector2
var floor_angle : float = 0
var body_angle : float = 0

var target

func _ready() -> void:
	hurtbox.area_entered.connect(_on_hurtbox_entered)


func _physics_process(delta: float) -> void:

	down_ray.global_rotation = 0
	ground_ray_contact = ground_ray.get_collision_point()

	# Add the gravity.
	if not is_on_floor():
		if velocity.y <= 0:
			velocity += Vector2.DOWN * UP_GRAV * delta
		else:
			velocity += Vector2.DOWN * DOWN_GRAV * delta

	orient_body_with_floor(delta)


func orient_body_with_floor(delta : float) -> void:
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


func _on_hurtbox_entered(area : Area2D) -> void:
	pass

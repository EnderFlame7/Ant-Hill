class_name ResourceDeposit extends Node2D

@onready var ground_ray_cast : RayCast2D = %GroundRayCast

var snapped_to_floor : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snap_to_floor()
	print("IM HERE ", global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not snapped_to_floor:
		snap_to_floor()


func snap_to_floor() -> void:
	if ground_ray_cast.get_collision_normal() and ground_ray_cast.is_colliding():
		var floor_angle : float = atan(ground_ray_cast.get_collision_normal().y / ground_ray_cast.get_collision_normal().x) + deg_to_rad(90)
		if rad_to_deg(floor_angle) >= 90:
			global_rotation = -(deg_to_rad(180) - floor_angle)
		else:
			global_rotation = floor_angle
		global_position = ground_ray_cast.get_collision_point()
		snapped_to_floor = true
	else:
		global_rotation = 0
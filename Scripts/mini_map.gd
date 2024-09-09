class_name MiniMap extends Control


var width
var height

var cam_x : float
var cam_y : float

var mouse_hovering : bool = false
var in_use : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mini_map = self
	width = size.x
	height = size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("lmb") and mouse_hovering:
		in_use = true
		cam_x = Global.MAP_WIDTH * (get_local_mouse_position().x / width)
		cam_y = Global.MAP_HEIGHT * (get_local_mouse_position().y / height)
		print(get_local_mouse_position().y)
	else:
		in_use = false


func get_map_to_camera_coords() -> Vector2:
	return Vector2(cam_x, cam_y)


func _on_mouse_entered() -> void:
	mouse_hovering = true


func _on_mouse_exited() -> void:
	mouse_hovering = false

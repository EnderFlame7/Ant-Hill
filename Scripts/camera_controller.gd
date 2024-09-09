class_name  Camera extends Camera2D

var cutscene_active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cutscene_active:
		pass
	elif Global.mini_map.in_use:
		global_position = lerp(global_position, Global.mini_map.get_map_to_camera_coords(), 30 * delta)
	else:
		pass

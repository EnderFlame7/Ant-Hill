class_name Whistle extends Node2D

@export var area_growth_rate : int
@onready var area_shape : CollisionShape2D = %AreaShape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("rmb"):
		global_position = get_global_mouse_position()
		area_shape.set_deferred("disabled", false)
		area_shape.shape.radius += area_growth_rate * delta
	else:
		area_shape.shape.radius = 25
		area_shape.set_deferred("disabled", true)

class_name Main extends Node2D

@onready var all_resource_deposits : Node2D = %ResourceDeposits
@onready var deposit_raycast : RayCast2D = %DepositRayCast

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.main = self
	spawn_resource_deposits()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_resource_deposits() -> void:
	deposit_raycast.global_position = Vector2(0, 0)
	while deposit_raycast.global_position.x < Global.MAP_WIDTH:
		deposit_raycast.global_position.x += randi_range(350, 700)
		deposit_raycast.force_raycast_update()
		if deposit_raycast.is_colliding():
			var resource_deposit : ResourceDeposit = preload("res://Scenes/resource_deposit.tscn").instantiate()
			resource_deposit.global_position = deposit_raycast.get_collision_point()
			resource_deposit.global_position.y -= 50
			all_resource_deposits.add_child(resource_deposit)

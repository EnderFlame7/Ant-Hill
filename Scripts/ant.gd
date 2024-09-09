class_name Ant extends Entity

var at_attention : bool = false

func _ready() -> void:
	super._ready()
	hurtbox.area_entered.connect(_on_hurtbox_entered)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if target:
		if target.global_position.x >= global_position.x:
			velocity.x = speed
		else:
			velocity.x = -speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _on_hurtbox_entered(area : Area2D) -> void:
	if area.is_in_group("whistle"):
		print("I AM AT ATTENTION!")
		at_attention = true
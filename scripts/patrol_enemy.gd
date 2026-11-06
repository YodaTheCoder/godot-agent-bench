class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

var _next_waypoint_index := 0

func next_waypoint_index() -> int:
	return _next_waypoint_index

func is_chasing() -> bool:
	if target == null:
		return false
	return global_position.distance_to(target.global_position) <= aggro_range

func _physics_process(_delta: float) -> void:
	if is_chasing():
		# Chasing behavior - move towards target
		velocity = direction_to_target() * speed
	else:
		# Patrol behavior
		if waypoints.size() == 0:
			# Idle behavior
			velocity = Vector2.ZERO
		else:
			# Move towards current waypoint
			var target_waypoint := waypoints[_next_waypoint_index]
			
			# Check if reached waypoint
			if global_position.distance_to(target_waypoint) <= 4.0:
				_next_waypoint_index += 1
				if _next_waypoint_index >= waypoints.size():
					_next_waypoint_index = 0
			
			velocity = global_position.direction_to(target_waypoint) * speed
	
	move_and_slide()
class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

var _current_waypoint_index := 0

func next_waypoint_index() -> int:
	return _current_waypoint_index

func is_chasing() -> bool:
	if target == null:
		return false
	var distance = global_position.distance_to(target.global_position)
	return distance <= aggro_range

func _physics_process(delta: float) -> void:
	var velocity_direction: Vector2
	
	if is_chasing():
		# Chasing behavior
		velocity_direction = direction_to_target()
	else:
		# Patrol behavior
		if waypoints.size() == 0:
			# Idle behavior
			velocity_direction = Vector2.ZERO
		else:
			# Check if reached current waypoint
			var current_waypoint = waypoints[_current_waypoint_index]
			var distance_to_waypoint = global_position.distance_to(current_waypoint)
			
			if distance_to_waypoint <= 4.0:
				# Move to next waypoint
				_current_waypoint_index += 1
				if _current_waypoint_index >= waypoints.size():
					_current_waypoint_index = 0  # Loop back to first waypoint
			
			# Move towards current waypoint
			current_waypoint = waypoints[_current_waypoint_index]
			velocity_direction = global_position.direction_to(current_waypoint)
	
	velocity = velocity_direction * speed
	move_and_slide()
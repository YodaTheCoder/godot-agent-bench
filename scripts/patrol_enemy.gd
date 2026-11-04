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
	if is_chasing():
		# Chasing the target
		velocity = direction_to_target() * speed
		# Do NOT change waypoint index while chasing
	else:
		# Patrolling or idle
		if waypoints.size() == 0:
			# Idle - no waypoints
			velocity = Vector2.ZERO
		else:
			# Patrolling
			var current_waypoint = waypoints[_current_waypoint_index]
			
			# Check if we've reached the waypoint (within 4 pixels)
			var distance_to_waypoint = global_position.distance_to(current_waypoint)
			if distance_to_waypoint <= 4.0:
				# Move to next waypoint and wrap around if needed
				_current_waypoint_index += 1
				if _current_waypoint_index >= waypoints.size():
					_current_waypoint_index = 0
			
			# Set velocity towards current waypoint  
			var direction_to_waypoint = global_position.direction_to(current_waypoint)
			velocity = direction_to_waypoint * speed
	
	move_and_slide()

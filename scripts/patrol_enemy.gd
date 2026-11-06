class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array = []
@export var aggro_range := 150.0

func next_waypoint_index() -> int:
	# Implementation will be added in _physics_process
	return 0

func is_chasing() -> bool:
	if target == null:
		return false
	var distance = global_position.distance_to(target.global_position)
	return distance <= aggro_range

func _physics_process(delta: float) -> void:
	if is_chasing():
		# Chasing behavior
		velocity = direction_to_target() * speed
	elif waypoints.size() > 0:
		# Patrolling behavior
		var current_waypoint_index = next_waypoint_index()
		var target_waypoint = waypoints[current_waypoint_index]
		
		# Check if we've reached the waypoint
		if global_position.distance_to(target_waypoint) <= 4.0:
			# Advance to next waypoint
			next_waypoint_index = (current_waypoint_index + 1) % waypoints.size()
			target_waypoint = waypoints[next_waypoint_index()]
		
		# Move towards current waypoint
		velocity = (target_waypoint - global_position).normalized() * speed
	else:
		# Idle behavior
		velocity = Vector2.ZERO

	move_and_slide()

func direction_to_target() -> Vector2:
	if target == null:
		return Vector2.ZERO
	return (target.global_position - global_position).normalized()
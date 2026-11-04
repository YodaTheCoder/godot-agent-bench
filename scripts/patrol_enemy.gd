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

func _physics_process(delta: float) -> void:
	if is_chasing():
		# Chasing the target - use parent class's direction_to_target method
		velocity = direction_to_target() * speed
	elif waypoints.size() > 0:
		# Patrolling
		var current_waypoint := waypoints[_next_waypoint_index]
		
		# Check if we've reached the waypoint
		if global_position.distance_to(current_waypoint) <= 4.0:
			_next_waypoint_index = (_next_waypoint_index + 1) % waypoints.size()
		
		# Move towards current waypoint
		velocity = global_position.direction_to(current_waypoint) * speed
	else:
		# Idle (no waypoints and no target)
		velocity = Vector2.ZERO
	
	move_and_slide()

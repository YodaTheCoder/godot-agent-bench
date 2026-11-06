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
	var distance = global_position.distance_to(target.global_position)
	return distance <= aggro_range

func _physics_process(delta: float) -> void:
	if is_chasing():
		# Chasing behavior
		velocity = direction_to_target() * speed
	else:
		# Patrol behavior or idle
		if waypoints.size() == 0:
			# Idle behavior
			velocity = Vector2.ZERO
		else:
			# Patrol behavior
			var current_waypoint = waypoints[_next_waypoint_index]
			
			# Check if we've reached the waypoint
			if global_position.distance_to(current_waypoint) <= 4.0:
				_next_waypoint_index += 1
				if _next_waypoint_index >= waypoints.size():
					_next_waypoint_index = 0
			
			# Set velocity towards current waypoint
			var direction = global_position.direction_to(current_waypoint)
			velocity = direction * speed
	
	move_and_slide()
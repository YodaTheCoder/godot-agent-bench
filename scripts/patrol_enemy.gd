class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array = PackedVector2Array()
@export var aggro_range := 150.0

var _current_waypoint_index := 0

func next_waypoint_index() -> int:
	return _current_waypoint_index

func is_chasing() -> bool:
	if target == null:
		return false
	return global_position.distance_to(target.global_position) <= aggro_range

func _physics_process(delta: float) -> void:
	if is_chasing():
		# Chasing behavior
		velocity = direction_to_target() * speed
	else:
		# Patrol behavior
		if waypoints.size() == 0:
			# Idle behavior
			velocity = Vector2.ZERO
		else:
			# Get current waypoint
			var target_waypoint := waypoints[_current_waypoint_index]
			
			# Check if reached waypoint
			if global_position.distance_to(target_waypoint) <= 4.0:
				# Move to next waypoint
				_current_waypoint_index = (_current_waypoint_index + 1) % waypoints.size()
			
			# Set velocity towards current waypoint
			velocity = global_position.direction_to(target_waypoint) * speed
	
	move_and_slide()
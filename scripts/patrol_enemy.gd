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
			# Patrolling behavior
			var current_waypoint := waypoints[_current_waypoint_index]
			var distance_to_waypoint := global_position.distance_to(current_waypoint)
			
			if distance_to_waypoint <= 4.0:
				# Reached waypoint, advance to next
				_current_waypoint_index = (_current_waypoint_index + 1) % waypoints.size()
			
			# Move towards current waypoint
			var direction_to_waypoint := global_position.direction_to(current_waypoint)
			velocity = direction_to_waypoint * speed
	
	move_and_slide()
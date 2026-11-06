class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

var _current_waypoint_index: int = 0


func next_waypoint_index() -> int:
	return _current_waypoint_index


func is_chasing() -> bool:
	if target == null:
		return false
	var distance: float = global_position.distance_to(target.global_position)
	return distance <= aggro_range


func _physics_process(delta: float) -> void:
	if is_chasing():
		# Chasing behavior
		velocity = direction_to_target() * speed
	else:
		# Patrol behavior
		if waypoints.size() == 0:
			velocity = Vector2.ZERO
		else:
			var target_waypoint: Vector2 = waypoints[_current_waypoint_index]
			
			# Check if we've reached the current waypoint
			var distance_to_waypoint: float = global_position.distance_to(target_waypoint)
			if distance_to_waypoint <= 4.0:
				# Advance to next waypoint
				_current_waypoint_index = (_current_waypoint_index + 1) % waypoints.size()
			
			# Move towards current waypoint
			var direction_to_waypoint: Vector2 = global_position.direction_to(target_waypoint)
			velocity = direction_to_waypoint * speed
	
	move_and_slide()
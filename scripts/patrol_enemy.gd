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
		velocity = direction_to_target() * speed
	elif waypoints.size() > 0:
		var current_waypoint = waypoints[_current_waypoint_index]
		
		# Check if we've reached the waypoint
		var distance_to_waypoint = global_position.distance_to(current_waypoint)
		if distance_to_waypoint <= 4.0:
			_current_waypoint_index += 1
			if _current_waypoint_index >= waypoints.size():
				_current_waypoint_index = 0
		
		# Move toward current waypoint
		var direction_to_waypoint = current_waypoint - global_position
		direction_to_waypoint = direction_to_waypoint.normalized()
		velocity = direction_to_waypoint * speed
	else:
		# No waypoints and no target - idle
		velocity = Vector2.ZERO
	
	move_and_slide()
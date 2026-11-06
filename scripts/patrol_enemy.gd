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
	var distance := global_position.distance_to(target.global_position)
	return distance <= aggro_range


func _physics_process(delta: float) -> void:
	var velocity_direction := Vector2.ZERO
	
	if is_chasing():
		# Chasing the target
		velocity_direction = direction_to_target()
	elif waypoints.size() > 0:
		# Patrolling, check if we've reached a waypoint
		var current_waypoint := waypoints[_current_waypoint_index]
		var distance_to_waypoint := global_position.distance_to(current_waypoint)
		
		if distance_to_waypoint <= 4.0:
			# Reached the waypoint, advance to next one
			_current_waypoint_index = (_current_waypoint_index + 1) % waypoints.size()
		
		# Move towards current waypoint (may have changed above)
		current_waypoint = waypoints[_current_waypoint_index]
		velocity_direction = global_position.direction_to(current_waypoint)
	else:
		# Idle - no waypoints and no target
		velocity_direction = Vector2.ZERO
	
	velocity = velocity_direction * speed
	move_and_slide()
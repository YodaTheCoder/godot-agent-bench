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
	var velocity_direction := Vector2.ZERO
	
	if is_chasing():
		# Chasing behavior
		velocity_direction = direction_to_target()
	elif waypoints.size() > 0:
		# Patrolling behavior
		var current_waypoint := waypoints[_current_waypoint_index]
		
		# Check if we've reached the waypoint
		if global_position.distance_to(current_waypoint) <= 4.0:
			_current_waypoint_index = (_current_waypoint_index + 1) % waypoints.size()
		
		# Move towards current waypoint
		velocity_direction = global_position.direction_to(current_waypoint)
	else:
		# Idle behavior
		velocity_direction = Vector2.ZERO
	
	velocity = velocity_direction * speed
	move_and_slide()
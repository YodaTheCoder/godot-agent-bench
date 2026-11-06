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
		# Chase the target
		velocity = direction_to_target() * speed
	else:
		# Patrol or idle
		if waypoints.size() == 0:
			# Idle
			velocity = Vector2.ZERO
		else:
			# Check if we reached the waypoint
			var current_waypoint := waypoints[_next_waypoint_index]
			var distance_to_waypoint := global_position.distance_to(current_waypoint)
			
			if distance_to_waypoint <= 4.0:
				# Reached waypoint, advance to next one
				_next_waypoint_index = (_next_waypoint_index + 1) % waypoints.size()
			
			# Move towards current waypoint
			var direction := global_position.direction_to(current_waypoint)
			velocity = direction * speed
	
	move_and_slide()

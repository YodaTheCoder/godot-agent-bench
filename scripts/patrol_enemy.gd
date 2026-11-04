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
	var distance = global_position.distance_to(target.global_position)
	return distance <= aggro_range

func _physics_process(delta: float) -> void:
	if is_chasing():
		velocity = direction_to_target() * speed
	else:
		if waypoints.size() == 0:
			velocity = Vector2.ZERO
		else:
			# Check if we need to advance to next waypoint
			var current_pos = global_position
			var target_pos = waypoints[_current_waypoint_index]
			
			if current_pos.distance_to(target_pos) <= 4.0:
				# We've reached this waypoint, advance to next
				_current_waypoint_index = (_current_waypoint_index + 1) % waypoints.size()
				# Recalculate target since index changed
				target_pos = waypoints[_current_waypoint_index]
			
			velocity = current_pos.direction_to(target_pos) * speed
	
	move_and_slide()

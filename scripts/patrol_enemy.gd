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
	return global_position.distance_to(target.global_position) <= aggro_range

func _physics_process(delta: float) -> void:
	if is_chasing():
		velocity = direction_to_target() * speed
	else:
		if waypoints.is_empty():
			velocity = Vector2.ZERO
		else:
			var waypoint := waypoints[_current_waypoint_index]
			if global_position.distance_to(waypoint) <= 4.0:
				_current_waypoint_index = (_current_waypoint_index + 1) % waypoints.size()
				waypoint = waypoints[_current_waypoint_index]
			velocity = global_position.direction_to(waypoint) * speed
	move_and_slide()

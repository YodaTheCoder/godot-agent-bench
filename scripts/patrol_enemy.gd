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
		velocity = direction_to_target() * speed
	else:
		if waypoints.is_empty():
			velocity = Vector2.ZERO
		else:
			var idx = next_waypoint_index()
			var waypoint = waypoints[idx]
			velocity = global_position.direction_to(waypoint) * speed
			if global_position.distance_to(waypoint) <= 4.0:
				idx = (idx + 1) % waypoints.size()
				_current_waypoint_index = idx
	move_and_slide()
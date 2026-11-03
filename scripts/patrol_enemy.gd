class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

var _waypoint_index := 0

func next_waypoint_index() -> int:
	return _waypoint_index

func is_chasing() -> bool:
	if target == null:
		return false
	return global_position.distance_to(target.global_position) <= aggro_range

func _physics_process(delta: float) -> void:
	if is_chasing():
		velocity = direction_to_target() * speed
	else:
		if waypoints.size() == 0:
			velocity = Vector2.ZERO
		else:
			var waypoint_pos := waypoints[_waypoint_index]
			if global_position.distance_to(waypoint_pos) <= 4.0:
				_waypoint_index = (_waypoint_index + 1) % waypoints.size()
				waypoint_pos = waypoints[_waypoint_index]
			velocity = global_position.direction_to(waypoint_pos) * speed
	move_and_slide()
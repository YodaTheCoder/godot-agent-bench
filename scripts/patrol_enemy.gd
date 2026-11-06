class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

func next_waypoint_index() -> int:
	if waypoints.is_empty():
		return 0
	return _waypoint_index

var _waypoint_index: int = 0

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
			var current_index := next_waypoint_index()
			var waypoint_pos := waypoints[current_index]
			if global_position.distance_to(waypoint_pos) <= 4.0:
				_waypoint_index = (_waypoint_index + 1) % waypoints.size()
			var target_index := next_waypoint_index()
			velocity = global_position.direction_to(waypoints[target_index]) * speed
	move_and_slide()
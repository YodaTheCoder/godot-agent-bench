class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

func next_waypoint_index() -> int:
	if waypoints.size() == 0:
		return 0
	return _waypoint_index

func is_chasing() -> bool:
	if target == null:
		return false
	return global_position.distance_to(target.global_position) <= aggro_range

var _waypoint_index := 0

func _physics_process(delta: float) -> void:
	if is_chasing():
		velocity = direction_to_target() * speed
	else:
		if waypoints.size() > 0:
			var current_waypoint = waypoints[next_waypoint_index()]
			var distance = global_position.distance_to(current_waypoint)
			if distance <= 4.0:
				_waypoint_index = (_waypoint_index + 1) % waypoints.size()
				current_waypoint = waypoints[next_waypoint_index()]
			velocity = global_position.direction_to(current_waypoint) * speed
		else:
			velocity = Vector2.ZERO
	move_and_slide()
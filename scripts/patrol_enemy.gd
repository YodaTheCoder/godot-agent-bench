class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

var _waypoint_index: int = 0


func next_waypoint_index() -> int:
	return _waypoint_index


func is_chasing() -> bool:
	if target == null:
		return false
	return global_position.distance_to(target.global_position) <= aggro_range


func _physics_process(_delta: float) -> void:
	if is_chasing():
		velocity = direction_to_target() * speed
	elif not waypoints.is_empty():
		var target_waypoint = waypoints[_waypoint_index]
		if global_position.distance_to(target_waypoint) <= 4.0:
			_waypoint_index = (_waypoint_index + 1) % waypoints.size()
			target_waypoint = waypoints[_waypoint_index]

		velocity = global_position.direction_to(target_waypoint) * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

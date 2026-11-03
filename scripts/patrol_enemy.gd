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
	else if waypoints.size() > 0:
		var current_waypoint := waypoints[_waypoint_index]
		if global_position.distance_to(current_waypoint) <= 4.0:
			_waypoint_index = (_waypoint_index + 1) % waypoints.size()
			current_waypoint = waypoints[_waypoint_index]
			velocity = (current_waypoint - global_position).normalized() * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
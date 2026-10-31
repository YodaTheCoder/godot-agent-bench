class_name PatrolEnemy
extends Enemy

## Distance (pixels) at which a waypoint counts as reached.
const ARRIVE_DISTANCE := 4.0

## Patrol route, in global coordinates. Visited in order, then from the start again.
@export var waypoints: PackedVector2Array
## The enemy chases `target` while it is at most this many pixels away.
@export var aggro_range := 150.0

var _waypoint_index := 0


func _physics_process(_delta: float) -> void:
	if is_chasing():
		velocity = direction_to_target() * speed
	elif waypoints.is_empty():
		velocity = Vector2.ZERO
	else:
		if global_position.distance_to(waypoints[_waypoint_index]) <= ARRIVE_DISTANCE:
			_waypoint_index = (_waypoint_index + 1) % waypoints.size()
		velocity = global_position.direction_to(waypoints[_waypoint_index]) * speed
	move_and_slide()


func next_waypoint_index() -> int:
	return _waypoint_index


func is_chasing() -> bool:
	if target == null:
		return false
	return global_position.distance_to(target.global_position) <= aggro_range

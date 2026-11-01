class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

var _waypoint_idx: int = 0

func next_waypoint_index() -> int:
	return _waypoint_idx

func is_chasing() -> bool:
	if target == null:
		return false
	var dist = global_position.distance_to(target.global_position)
	return dist <= aggro_range

func _physics_process(_delta: float) -> void:
	if is_chasing():
		velocity = direction_to_target() * speed
	elif waypoints.size() > 0:
		var idx = next_waypoint_index()
		var target_pos = waypoints[idx]
		# check arrival
		if global_position.distance_to(target_pos) <= 4.0:
			# advance one waypoint
			_waypoint_idx = (idx + 1) % waypoints.size()
			idx = _waypoint_idx
			target_pos = waypoints[idx]
		velocity = global_position.direction_to(target_pos) * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

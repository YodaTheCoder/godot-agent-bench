class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

var _current_waypoint_index: int = 0

func next_waypoint_index() -> int:
	if waypoints.size() == 0:
		return 0
	return _current_waypoint_index

func is_chasing() -> bool:
	if target == null:
		return false
	var distance := global_position.distance_to(target.global_position)
	return distance <= aggro_range

func _physics_process(_delta: float) -> void:
	if is_chasing():
		velocity = direction_to_target() * speed
	else:
		if waypoints.size() > 0:
			var current_index := next_waypoint_index()
			var waypoint := waypoints[current_index]
			var distance_to_waypoint := global_position.distance_to(waypoint)
			if distance_to_waypoint <= 4.0:
				_current_waypoint_index = (_current_waypoint_index + 1) % waypoints.size()
				current_index = next_waypoint_index()
				waypoint = waypoints[current_index]
			velocity = global_position.direction_to(waypoint) * speed
		else:
			velocity = Vector2.ZERO
	move_and_slide()

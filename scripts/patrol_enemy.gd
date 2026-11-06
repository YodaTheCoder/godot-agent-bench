class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

var _waypoint_index := 0

func next_waypoint_index() -> int:
	return _waypoint_index

func is_chasing() -> bool:
	return target != null and global_position.distance_to(target.global_position) <= aggro_range

func _physics_process(delta: float) -> void:
	if is_chasing():
		velocity = direction_to_target() * speed
	else:
		if waypoints.is_empty():
			velocity = Vector2.ZERO
		else:
			if global_position.distance_to(waypoints[_waypoint_index]) <= 4.0:
				_waypoint_index = (_waypoint_index + 1) % waypoints.size()
			velocity = global_position.direction_to(waypoints[_waypoint_index]) * speed
	move_and_slide()

func _ready() -> void:
	super._ready()
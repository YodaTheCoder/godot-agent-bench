class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range: float = 150.0

var _next_index: int = 0

func next_waypoint_index() -> int:
    return _next_index

func is_chasing() -> bool:
    if target == null:
        return false
    if global_position.distance_to(target.global_position) <= aggro_range:
        return true
    return false

func _physics_process(delta: float) -> void:
    if is_chasing():
        velocity = direction_to_target() * speed
    else:
        if waypoints.is_empty():
            velocity = Vector2.ZERO
        else:
            # Check if reached current waypoint
            var current_wp = waypoints[_next_index]
            if global_position.distance_to(current_wp) <= 4.0:
                _next_index = (_next_index + 1) % waypoints.size()
            # After possible advance compute direction to current waypoint again
            var dir = global_position.direction_to(waypoints[_next_index])
            velocity = dir * speed
    move_and_slide()

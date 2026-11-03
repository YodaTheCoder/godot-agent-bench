class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array
@export var aggro_range := 150.0

func next_waypoint_index() -> int:
    return 0 if waypoints.is_empty() else waypoints.size() - 1

func is_chasing() -> bool:
    if target == null:
        return false
    return global_position.distance_to(target.global_position) <= aggro_range

func _physics_process(_delta: float) -> void:
    if is_chasing():
        velocity = direction_to_target() * speed
    elif not waypoints.is_empty():
        var current_idx := next_waypoint_index()
        var current_wp := waypoints[current_idx]
        if global_position.distance_to(current_wp) <= 4.0:
            current_idx = (current_idx + 1) % waypoints.size()
        velocity = global_position.direction_to(waypoints[current_idx]) * speed
    else:
        velocity = Vector2.ZERO
    move_and_slide()
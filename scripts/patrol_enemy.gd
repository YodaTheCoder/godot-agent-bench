# Add a patrolling enemy that chases the player when it gets close

class_name PatrolEnemy
extends Enemy

@export var waypoints: PackedVector2Array = PackedVector2Array()
@export var aggro_range := 150.0

var _current_waypoint_index := 0

func next_waypoint_index() -> int:
	return _current_waypoint_index

func is_chasing() -> bool:
	if target == null:
		return false
	return global_position.distance_to(target.global_position) <= aggro_range

func _physics_process(delta: float) -> void:
	# Chasing behavior
	if is_chasing():
		velocity = direction_to_target() * speed
		# Do not change waypoint index while chasing
		move_and_slide()
		return
	
	# Patrolling behavior
	if waypoints.size() > 0:
		var current_waypoint := waypoints[_current_waypoint_index]
		var distance_to_waypoint := global_position.distance_to(current_waypoint)
		
		# If reached the waypoint, advance to next one
		if distance_to_waypoint <= 4.0:
			_current_waypoint_index = (_current_waypoint_index + 1) % waypoints.size()
			
		# Set velocity towards current waypoint
		velocity = global_position.direction_to(current_waypoint) * speed
		move_and_slide()
		return
	
	# Idle behavior (no waypoints and no target)
	velocity = Vector2.ZERO
	move_and_slide()
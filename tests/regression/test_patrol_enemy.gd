extends GutTest

var patrol_enemy: PatrolEnemy

func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())

func test_initialization() -> void:
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_not_null(patrol_enemy.get_node("Health"))

func test_patrol_movement() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	
	# Initially at waypoint 0
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Move to waypoint 1
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Move to waypoint 2
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Move back to waypoint 0
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

func test_arrival_threshold() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

func test_not_at_waypoint() -> void:
	patrol_enemy.waypoints = Packed
	# Wait, I should check the requirements again.
	# "if the enemy's global_position is within 4.0 pixels of waypoints[next_waypoint_index()] (distance <= 4.0), the waypoint is reached and the index advances to the next waypoint"
	# "Not yet at the waypoint: the index stays the same and velocity points at the waypoint"
	pass

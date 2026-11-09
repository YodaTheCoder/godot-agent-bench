extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_instantiates_correctly() -> void:
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_eq(patrol_enemy.get_node("Health"), patrol_enemy.health)
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process multiple times to advance waypoints
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
	
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Move to second waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
		
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Move to third waypoint
	patrol_enemy.global_position = Vector2(100, 100)
	
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
		
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_at_waypoint() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)]
	
	# Place enemy at waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Place enemy near waypoint (within 4px threshold)
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	assert_eq(patrol_enemy.next_waypoint_index(), 1) # Should not advance yet
	# Move to next waypoint
	patrol_enemy.global_position = Vector2(5, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	assert_eq(patrol_enemy.next_waypoint_index(), 2) # Now should advance


func test_chasing_behavior() -> void:
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 100)
	patrol_enemy.target = target
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0)])
	
	# Test distance within aggro range (should be chasing)
	patrol_enemy.global_position = Vector2(50, 50) # Distance is about 70px
	assert_true(patrol_enemy.is_chasing())
	
	# Test distance outside aggro range (should not be chasing)
	patrol_enemy.global_position = Vector2(200, 200) # Distance is 200px
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range to include the target
	patrol_enemy.aggro_range = 250.0
	patrol_enemy.global_position = Vector2(200, 200) # Distance is still 200px
	assert_true(patrol_enemy.is_chasing())
	
	# Test chasing behavior - velocity should be towards target
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity.length(), patrol_enemy.speed, 0.001)


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.target = null
	
	patrol_enemy._physics_process(1.0 / 60.0)
	
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_velocity_towards_waypoint() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(300, 0)]
	
	# Place enemy at origin
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Velocity should be in direction of waypoint with length speed
	assert_almost_eq(patrol_enemy.velocity.length(), patrol_enemy.speed, 0.001)
	assert_almost_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0), Vector2(0.001, 0.001))
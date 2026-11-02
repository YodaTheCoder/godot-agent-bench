extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_instantiates_correctly() -> void:
	assert_is_instance_of(patrol_enemy, PatrolEnemy)
	assert_is_instance_of(patrol_enemy, Enemy)
	assert_true(patrol_enemy.has_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	# Set up waypoints
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.waypoints = waypoints
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process multiple times to move through waypoints
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should have moved to next waypoint
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Continue moving
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
	
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Continue and wrap around
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
	
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_at_waypoint() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.waypoints = waypoints
	
	# Place enemy at waypoint position (should count as arrival)
	patrol_enemy.global_position = Vector2(3, 0)  # Within 4 pixel threshold
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should have moved to next waypoint
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_chasing_behavior() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.waypoints = waypoints
	
	# Set up a target
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)  # Within aggro range
	patrol_enemy.target = target
	
	# Enemy should be chasing (within aggro range)
	assert_true(patrol_enemy.is_chasing())
	
	# Set velocity towards target
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should move toward target, not waypoint
	assert_not_eq(patrol_enemy.velocity, Vector2.ZERO)


func test_is_chasing_logic() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0)]
	patrol_enemy.waypoints = waypoints
	
	# No target - should not be chasing
	assert_false(patrol_enemy.is_chasing())
	
	# Set a target
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	# Should be chasing (100px away, aggro range is 150px)
	assert_true(patrol_enemy.is_chasing())
	
	# Move target further away
	target.global_position = Vector2(200, 0)
	# Should not be chasing anymore (200px > 150px aggro range)
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range to 250px
	patrol_enemy.aggro_range = 250.0
	# Should now be chasing again (200px < 250px)
	assert_true(patrol_enemy.is_chasing())


func test_idle_behavior() -> void:
	# Empty waypoints, no target
	assert_eq(patrol_enemy.waypoints.size(), 0)
	assert_null(patrol_enemy.target)
	
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should be idle (velocity = Vector2.ZERO)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
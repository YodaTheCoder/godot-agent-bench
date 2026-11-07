extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_instantiates_correctly() -> void:
	assert_eq(patrol_enemy.get_script().resource_path, "res://scripts/patrol_enemy.gd")
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_true(patrol_enemy.has_node("Health"))


func test_patrol_movement() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.waypoints = waypoints
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process to move to next waypoint
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Move to second waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Move to third waypoint (and wrap around)
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_at_waypoint() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.waypoints = waypoints
	
	# Place enemy at waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Place enemy near waypoint (within 4px threshold)
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1) # Should not advance yet
	
	
func test_chasing_behavior() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	
	# Set a target
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(50, 0)
	patrol_enemy.target = target
	
	# Enemy should not be chasing (too far)
	assert_false(patrol_enemy.is_chasing())
	
	# Move target closer
	target.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_true(patrol_enemy.is_chasing())
	
	# Move target further away
	target.global_position = Vector2(200, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range
	patrol_enemy.aggro_range = 250.0
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_true(patrol_enemy.is_chasing())


func test_chasing_does_not_change_waypoint() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy._current_waypoint_index = 1 # Start at second waypoint
	
	# Set a target
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(50, 0)
	patrol_enemy.target = target
	
	# Enemy should be chasing (target within aggro range)
	assert_true(patrol_enemy.is_chasing())
	
	# Call physics process - should chase but not change waypoint index
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1) # Should remain at same waypoint


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	
	# Call physics process with no waypoints and no target
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
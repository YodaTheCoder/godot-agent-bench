extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_creation_with_default_values():
	# Test that it creates a PatrolEnemy with correct default values
	assert_eq(patrol_enemy.waypoints.size(), 0, "Waypoints should be empty by default")
	assert_eq(patrol_enemy.aggro_range, 150.0, "Aggro range should be 150.0 by default")
	assert_eq(patrol_enemy._next_waypoint_index, 0, "Next waypoint index should be 0 by default")


func test_waypoint_navigation():
	# Test waypoint navigation
	var waypoints = PackedVector2Array([
		Vector2(100, 100),
		Vector2(200, 100),
		Vector2(200, 200)
	])
	patrol_enemy.waypoints = waypoints
	
	# Test initial state
	assert_eq(patrol_enemy.next_waypoint_index(), 0, "Should start at waypoint index 0")
	
	# Test waypoint progression
	patrol_enemy._next_waypoint_index = 1
	assert_eq(patrol_enemy.next_waypoint_index(), 1, "Should return correct waypoint index")


func test_chasing_behavior():
	# Test chasing behavior
	assert_eq(patrol_enemy.is_chasing(), false, "Should not be chasing without target")
	
	# Set up a target
	var target = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# Test with target but outside aggro range
	patrol_enemy.global_position = Vector2(0, 0)
	target.global_position = Vector2(200, 200)  # Beyond aggro range (150)
	assert_eq(patrol_enemy.is_chasing(), false, "Should not be chasing when target is outside aggro range")
	
	# Test with target inside aggro range
	target.global_position = Vector2(100, 100)  # Within aggro range
	assert_eq(patrol_enemy.is_chasing(), true, "Should be chasing when target is within aggro range")


func test_inheritance():
	# Test that it inherits all Enemy functionality correctly
	assert_true(patrol_enemy is Enemy, "PatrolEnemy should inherit from Enemy")
	
	# Test inherited properties
	assert_eq(patrol_enemy.points, 10, "Should inherit points property")
	assert_eq(patrol_enemy.speed, 80.0, "Should inherit speed property")
	
	# Test inherited methods
	assert_true(has_method(patrol_enemy, "direction_to_target"), "Should inherit direction_to_target method")
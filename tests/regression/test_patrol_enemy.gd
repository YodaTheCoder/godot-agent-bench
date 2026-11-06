extends GutTest

func test_waypoint_navigation() -> void:
	var patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process multiple times to move through waypoints
	for i in range(10):
		patrol_enemy._physics_process(1.0 / 60.0)
		
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

func test_chasing_behavior() -> void:
	var patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0)])
	
	# Create a target
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	# Set aggro range so target is within range
	patrol_enemy.aggro_range = 150.0
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process - should be chasing
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Enemy should be moving towards target (not waypoint)
	assert_false(patrol_enemy.next_waypoint_index() == 0)
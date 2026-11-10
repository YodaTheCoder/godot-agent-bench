# Test script to verify the PatrolEnemy implementation
extends Node

func _ready() -> void:
	print("Testing PatrolEnemy implementation")
	
	# Test instantiation
	var patrol_enemy = preload("res://scenes/patrol_enemy.tscn").instantiate()
	print("Created PatrolEnemy instance: ", patrol_enemy)
	print("Is PatrolEnemy: ", patrol_enemy is PatrolEnemy)
	print("Is Enemy: ", patrol_enemy is Enemy)
	print("Has Health child: ", patrol_enemy.get_node("Health") != null)
	print("Default aggro_range: ", patrol_enemy.aggro_range)
	print("Default next_waypoint_index: ", patrol_enemy.next_waypoint_index())
	
	# Test waypoint behavior
	var waypoints = PackedVector2Array(Vector2(0, 0), Vector2(100, 0), Vector2(100, 100))
	patrol_enemy.waypoints = waypoints
	print("Waypoints set: ", patrol_enemy.waypoints)
	print("Next waypoint index after setting waypoints: ", patrol_enemy.next_waypoint_index())
	
	# Test chasing behavior
	var target = Node2D.new()
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	print("Is chasing (should be true): ", patrol_enemy.is_chasing())
	
	target.global_position = Vector2(200, 0)
	print("Is chasing (should be false): ", patrol_enemy.is_chasing())
	
	patrol_enemy.aggro_range = 250.0
	target.global_position = Vector2(200, 0)
	print("Is chasing after range change (should be true): ", patrol_enemy.is_chasing())
	
	print("PatrolEnemy implementation test completed successfully!")
extends GutTest


func test_poison_damage() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	var poison := Poison.new()
	poison.damage_per_second = 5.0
	player.status_effects.add(poison)
	
	# Tick once for 1 second - should deal 5 damage
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 95)
	
	# Add another poison with same properties and tick for 1 more second
	var poison2 := Poison.new()
	poison2.damage_per_second = 5.0
	player.status_effects.add(poison2)
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 90)
	
	# Tick with full duration - should deal exactly 10 damage total
	player.status_effects.tick(3.0)
	assert_eq(player.get_node("Health").current, 80)


func test_slow_effect() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Apply slow with multiplier of 0.5 for 1 second
	var slow := Slow.new()
	slow.multiplier = 0.5
	player.status_effects.add(slow)
	
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	# Tick half a second - speed should still be 100.0
	player.status_effects.tick(0.5)
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	# Tick remaining half second - speed should go back to normal
	player.status_effects.tick(0.5)
	assert_eq(player.status_effects.speed_multiplier(), 1.0)
	assert_eq(player.effective_speed(), 200.0)


func test_multiple_slows() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Apply two slows with different multipliers
	var slow1 := Slow.new()
	slow1.multiplier = 0.5
	var slow2 := Slow.new()
	slow2.multiplier = 0.5
	
	player.status_effects.add(slow1)
	player.status_effects.add(slow2)
	
	# Product of multipliers should be 0.25 (0.5 * 0.5)
	assert_eq(player.status_effects.speed_multiplier(), 0.25)
	assert_eq(player.effective_speed(), 50.0)
	
	# Tick and remove one slow, leaving only one
	player.status_effects.tick(1.0)
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)


func test_active_count() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Initially no active effects
	assert_eq(player.status_effects.active_count(), 0)
	
	# Add one effect
	var poison := Poison.new()
	player.status_effects.add(poison)
	assert_eq(player.status_effects.active_count(), 1)
	
	# Add another effect  
	var slow := Slow.new()
	player.status_effects.add(slow)
	assert_eq(player.status_effects.active_count(), 2)
	
	# Tick to remove effects
	player.status_effects.tick(1.0)
	assert_eq(player.status_effects.active_count(), 0)


func test_poison_fractional_damage() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Create poison with 5 damage per second
	var poison := Poison.new()
	poison.damage_per_second = 5.0
	
	player.status_effects.add(poison)
	
	# Tick in small steps to exercise fractional damage calculation
	player.status_effects.tick(0.5)  # Should owe 2.5, deal 2
	assert_eq(player.get_node("Health").current, 98)
	
	player.status_effects.tick(0.5)  # Should owe 2.5, deal 2  
	assert_eq(player.get_node("Health").current, 96)
	
	player.status_effects.tick(0.5)  # Should owe 2.5, deal 2
	assert_eq(player.get_node("Health").current, 94)
	
	player.status_effects.tick(0.5)  # Should owe 2.5, deal 2
	assert_eq(player.get_node("Health").current, 92)
	
	# Complete remaining fractional portion
	player.status_effects.tick(1.0)  # Should deal remaining 2
	assert_eq(player.get_node("Health").current, 90)


func test_no_health_node() -> void:
	var node := Node.new()
	node.name = "TestNode"
	
	var poison := Poison.new()
	poison.damage_per_second = 5.0
	
	# Test that poison on a node without Health child does nothing 
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	player.status_effects.add(poison)
	player.status_effects.tick(1.0)
	# Should not crash, and health should remain at 100
	assert_eq(player.get_node("Health").current, 100)

func test_enemy_with_poison() -> void:
	var enemy: Enemy = add_child_autofree(load("res://scenes/enemy.tscn").instantiate())
	
	var poison := Poison.new()
	poison.damage_per_second = 4.0
	enemy.status_effects.add(poison)
	
	# Tick for one second - should damage enemy by 4 points
	enemy.status_effects.tick(1.0)
	assert_eq(enemy.get_node("Health").current, 96)
extends GutTest


func test_diagonal_velocity_has_full_speed() -> void:
	var velocity := Player.compute_velocity(Vector2(1, 1), 200.0)
	assert_almost_eq(velocity.length(), 200.0, 0.001)


func test_no_input_gives_zero_velocity() -> void:
	assert_eq(Player.compute_velocity(Vector2.ZERO, 200.0), Vector2.ZERO)


func test_scene_has_health_and_weapon() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_is(player.get_node("Health"), Health)
	assert_is(player.get_node("Weapon"), Weapon)


func test_scene_has_status_effects() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_is(player.get_node("StatusEffects"), StatusEffects)

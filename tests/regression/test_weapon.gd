extends GutTest

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_first_shot_fires() -> void:
	assert_true(weapon.try_fire(0.0))


func test_immediate_second_shot_is_blocked() -> void:
	weapon.try_fire(0.0)
	assert_false(weapon.try_fire(0.0))

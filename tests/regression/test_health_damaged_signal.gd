extends GutTest

var health: Health


func before_each() -> void:
	health = Health.new()
	health.max_health = 100
	add_child_autofree(health)


func test_damaged_signal_emitted_on_damage() -> void:
	watch_signals(health)
	health.damage(30)
	assert_signal_emitted(health, "damaged")
	assert_eq(health.current, 70)


func test_damaged_signal_parameters() -> void:
	var damaged_amount = 0
	var damaged_remaining = 0
	
	health.connect("damaged", func(amount, remaining):
		damaged_amount = amount
		damaged_remaining = remaining
	)
	
	health.damage(30)
	assert_eq(damaged_amount, 30)
	assert_eq(damaged_remaining, 70)


func test_damaged_signal_not_emitted_on_zero_damage() -> void:
	watch_signals(health)
	health.damage(0)
	assert_signal_not_emitted(health, "damaged")


func test_damaged_signal_not_emitted_after_death() -> void:
	watch_signals(health)
	health.damage(100) # Kill it
	assert_signal_emitted(health, "died")
	
	# Further damage should not emit damaged signal
	health.damage(10)
	assert_signal_not_emitted(health, "damaged")


func test_damaged_signal_on_lethal_hit() -> void:
	var damaged_amount = 0
	var damaged_remaining = 0
	
	health.connect("damaged", func(amount, remaining):
		damaged_amount = amount
		damaged_remaining = remaining
	)
	
	health.damage(150) # More than current health
	assert_eq(damaged_amount, 100) # Should be the remaining health
	assert_eq(damaged_remaining, 0)
	assert_signal_emitted(health, "died")


func test_damaged_signal_order() -> void:
	var damaged_called = false
	var died_called = false
	
	health.connect("damaged", func(amount, remaining):
		damaged_called = true
		assert_eq(died_called, false) # damaged should be called before died
	)
	
	health.connect("died", func():
		died_called = true
		assert_eq(damaged_called, true) # died should be called after damaged
	)
	
	health.damage(100)
	assert_eq(damaged_called, true)
	assert_eq(died_called, true)
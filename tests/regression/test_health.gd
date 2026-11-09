extends GutTest

var health: Health


func before_each() -> void:
	health = Health.new()
	health.max_health = 100
	add_child_autofree(health)


func test_starts_at_max_health() -> void:
	assert_eq(health.current, 100)


func test_damage_reduces_current() -> void:
	health.damage(30)
	assert_eq(health.current, 70)


func test_died_emitted_at_zero() -> void:
	watch_signals(health)
	health.damage(100)
	assert_eq(health.current, 0)
	assert_signal_emitted(health, "died")


func test_died_not_emitted_while_alive() -> void:
	watch_signals(health)
	health.damage(99)
	assert_signal_not_emitted(health, "died")


func test_heal_restores_health_below_max() -> void:
	health.damage(50)
	health.heal(20)
	assert_eq(health.current, 70)


func test_damaged_signal_emitted_on_damage() -> void:
	var damaged_amount = 0
	var damaged_remaining = 0
	
	# Connect to the damaged signal
	health.connect("damaged", func(amount, remaining):
		damaged_amount = amount
		damaged_remaining = remaining
	)
	
	# Test that damage emits damaged signal with correct values
	health.damage(30)
	assert_eq(damaged_amount, 30)
	assert_eq(damaged_remaining, 70)


func test_damaged_signal_not_emitted_on_zero_damage() -> void:
	var damaged_emitted = false
	
	# Connect to the damaged signal
	health.connect("damaged", func(amount, remaining):
		damaged_emitted = true
	)
	
	# Test that damage(0) does not emit damaged signal
	health.damage(0)
	assert_eq(damaged_emitted, false)


func test_damaged_signal_emitted_on_kill() -> void:
	var damaged_amount = 0
	var damaged_remaining = 0
	var died_emitted = false
	
	# Connect to the signals
	health.connect("damaged", func(amount, remaining):
		damaged_amount = amount
		damaged_remaining = remaining
	)
	health.connect("died", func():
		died_emitted = true
	)
	
	# Test that lethal damage emits damaged first, then died
	health.damage(150)
	assert_eq(damaged_amount, 100)  # Should be the actual amount lost
	assert_eq(damaged_remaining, 0)  # Should be remaining health
	assert_eq(died_emitted, true)


func test_damaged_signal_not_emitted_after_death() -> void:
	var damaged_emitted = false
	
	# Connect to the damaged signal
	health.connect("damaged", func(amount, remaining):
		damaged_emitted = true
	)
	
	# Kill the health first
	health.damage(100)
	
	# Try to damage again after death
	health.damage(10)
	assert_eq(damaged_emitted, false)  # Should not have emitted again


func test_damaged_signal_emitted_multiple_times() -> void:
	var damaged_events = []
	
	# Connect to the damaged signal
	health.connect("damaged", func(amount, remaining):
		damaged_events.append({"amount": amount, "remaining": remaining})
	)
	
	# Test multiple damage calls
	health.damage(30)
	health.damage(20)
	
	assert_eq(damaged_events.size(), 2)
	assert_eq(damaged_events[0]["amount"], 30)
	assert_eq(damaged_events[0]["remaining"], 70)
	assert_eq(damaged_events[1]["amount"], 20)
	assert_eq(damaged_events[1]["remaining"], 50)

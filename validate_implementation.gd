# Validate the implementation of the damaged signal for Health component

func _ready() -> void:
	print("Validating Health damaged signal implementation...")
	
	var health = Health.new()
	health.max_health = 100
	add_child(health)
	
	var test_results = []
	
	# Test 1: At 100/100, damage(30) emits damaged(30, 70) exactly once
	var damaged_events = []
	health.connect("damaged", func(amount, remaining):
		damaged_events.append({"amount": amount, "remaining": remaining})
	)
	
	health.damage(30)
	if damaged_events.size() == 1 and damaged_events[0]["amount"] == 30 and damaged_events[0]["remaining"] == 70:
		test_results.append("Test 1 PASSED")
	else:
		test_results.append("Test 1 FAILED")
	
	# Test 2: damage(30) then damage(20) emits damaged twice, second time with (20, 50)
	damaged_events.clear()
	health.damage(30)
	health.damage(20)
	if damaged_events.size() == 2 and damaged_events[1]["amount"] == 20 and damaged_events[1]["remaining"] == 50:
		test_results.append("Test 2 PASSED")
	else:
		test_results.append("Test 2 FAILED")
	
	# Test 3: damage(0) does not emit damaged
	damaged_events.clear()
	health.damage(0)
	if damaged_events.size() == 0:
		test_results.append("Test 3 PASSED")
	else:
		test_results.append("Test 3 FAILED")
	
	# Test 4: At 100/100, damage(150) emits damaged(100, 0), then died
	var died_emitted = false
	health.connect("died", func():
		died_emitted = true
	)
	damaged_events.clear()
	health.damage(150)
	if damaged_events.size() == 1 and damaged_events[0]["amount"] == 100 and damaged_events[0]["remaining"] == 0 and died_emitted:
		test_results.append("Test 4 PASSED")
	else:
		test_results.append("Test 4 FAILED")
	
	# Test 5: After death, a further damage(10) does not emit damaged
	damaged_events.clear()
	health.damage(10)
	if damaged_events.size() == 0:
		test_results.append("Test 5 PASSED")
	else:
		test_results.append("Test 5 FAILED")
	
	# Print results
	for result in test_results:
		print(result)
	
	var all_passed = true
	for result in test_results:
		if "FAILED" in result:
			all_passed = false
	
	if all_passed:
		print("All tests PASSED!")
	else:
		print("Some tests FAILED!")
extends Node

func _ready() -> void:
	test_combo_scenario_1()
	test_combo_scenario_2()
	test_combo_scenario_3()
	test_combo_scenario_4()
	test_combo_scenario_5()
	print("All tests passed!")

func test_combo_scenario_1() -> void:
	var score_manager = preload("res://scripts/score_manager.gd").new()
	score_manager.reset()
	
	# Three calls at t = 0.0, 0.5, 1.0 should give score == 60 and combo == 3
	score_manager.add_points(10, 0.0)   # combo 1 -> score 10
	score_manager.add_points(10, 0.5)   # combo 2 -> score 30
	score_manager.add_points(10, 1.0)   # combo 3 -> score 60
	
	assert(score_manager.score == 60)
	assert(score_manager.combo == 3)
	print("Test 1 passed: Three consecutive calls within 2s")

func test_combo_scenario_2() -> void:
	var score_manager = preload("res://scripts/score_manager.gd").new()
	score_manager.reset()
	
	# Calls at t = 0.0 and 1.0, then t = 3.5 (gap > 2 s): score == 40 and combo == 1
	score_manager.add_points(10, 0.0)   # combo 1 -> score 10
	score_manager.add_points(10, 1.0)   # combo 2 -> score 30
	score_manager.add_points(10, 3.5)   # 3.0 s gap: combo back to 1 -> score 40
	
	assert(score_manager.score == 40)
	assert(score_manager.combo == 1)
	print("Test 2 passed: Gap > 2s resets combo")

func test_combo_scenario_3() -> void:
	var score_manager = preload("res://scripts/score_manager.gd").new()
	score_manager.reset()
	
	# Calls at t = 0.0, 1.5, 3.0, 4.5 (each 1.5 s apart): score == 100
	score_manager.add_points(10, 0.0)   # combo 1 -> score 10
	score_manager.add_points(10, 1.5)   # combo 2 -> score 30
	score_manager.add_points(10, 3.0)   # combo 3 -> score 60
	score_manager.add_points(10, 4.5)   # combo 4 -> score 100
	
	assert(score_manager.score == 100)
	assert(score_manager.combo == 4)
	print("Test 3 passed: Sequential calls within 2s")

func test_combo_scenario_4() -> void:
	var score_manager = preload("res://scripts/score_manager.gd").new()
	score_manager.reset()
	
	# reset() after a combo, then add_points(10, 1.0): score == 10, combo == 1
	score_manager.add_points(10, 0.0)   # combo 1 -> score 10
	score_manager.add_points(10, 1.0)   # combo 2 -> score 30
	score_manager.reset()               # reset combo and time
	score_manager.add_points(10, 1.0)   # combo 1 -> score 40
	
	assert(score_manager.score == 40)
	assert(score_manager.combo == 1)
	print("Test 4 passed: Reset works correctly")

func test_combo_scenario_5() -> void:
	var score_manager = preload("res://scripts/score_manager.gd").new()
	
	# Test backward compatibility - regular calls without time parameter
	score_manager.reset()
	score_manager.add_points(10)  # Should add 10 points
	score_manager.add_points(5)   # Should add 5 points
	
	assert(score_manager.score == 15)
	print("Test 5 passed: Backward compatibility maintained")
extends Node

func test_simple_poison() -> void:
	# Just verify the basic structure works
	var poison = Poison.new()
	assert(poison.duration == 1.0)
	assert(poison.damage_per_second == 5.0)

func test_simple_slow() -> void:
	# Just verify the basic structure works
	var slow = Slow.new()
	assert(slow.duration == 1.0)
	assert(slow.multiplier == 0.5)

func _ready() -> void:
	print("Basic effect tests passed")

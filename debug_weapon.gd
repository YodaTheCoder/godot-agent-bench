extends Node

func _ready():
	# Just run a basic test to see how fire_rate is currently used
	print("Current weapon implementation analysis:")
	
	# Let's manually calculate what the current code does with fire_rate = 4.0
	var fire_rate = 4.0
	var last_shot_time = 0.0
	var now = 0.25
	
	# Current buggy approach: if now - last_shot_time < fire_rate
	var time_since_last_shot = now - last_shot_time
	print("With fire_rate = %s, now = %s, last_shot_time = %s" % [fire_rate, now, last_shot_time])
	print("Time since last shot = %s" % time_since_last_shot)
	print("Buggy condition (now - last_shot_time < fire_rate): %s" % (time_since_last_shot < fire_rate))
	
	# What it SHOULD be: if time_since_last_shot < 1.0 / fire_rate
	var required_interval = 1.0 / fire_rate
	print("Required interval between shots = 1.0 / %s = %s" % [fire_rate, required_interval])
	print("Should allow shot when time since last shot >= required interval: %s" % (time_since_last_shot >= required_interval))

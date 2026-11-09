# Script to test our wave timing calculations

extends Node

func test_timing():
	# Worked example: wave 0 = 3 enemies, interval = 0.5; wave 1 = 2 enemies, interval = 0.25; wave_delay = 1.0
	var wave_configs = [
		{count=3, interval=0.5},
		{count=2, interval=0.25}
	]
	
	var wave_delay = 1.0
	
	print("Calculating spawn times...")
	var current_time = 0.0
	var spawn_times = []
	
	for wave_index in range(wave_configs.size()):
		var wave = wave_configs[wave_index]
		print("Wave %d starts at time %.2f" % [wave_index, current_time])
		
		for enemy_index in range(wave.count):
			spawn_times.append(current_time)
			print("  Enemy %d of wave %d spawns at time %.2f" % [enemy_index, wave_index, current_time])
			current_time += wave.interval
		
		# Schedule next wave after this wave's last enemy plus delay
		next_wave_start = current_time + wave_delay
		print("  Wave %d ends at time %.2f, next wave starts at %.2f" %
			 [wave_index, current_time - wave.interval, next_wave_start])
		current_time += wave_delay
	
	print("\nExpected schedule:")
	print("0.0: Enemy 0 of wave 0")
	print("0.5: Enemy 1 of wave 0") 
	print("1.0: Enemy 2 of wave 0")
	print("2.0: Enemy 0 of wave 1 (wave 0 ends at time 1.0, delay = 1.0)")
	print("2.25: Enemy 1 of wave 1")
	print("All waves finished at the end")

# Run test
test_timing()
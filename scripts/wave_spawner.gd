class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0   # float, seconds
@export var autostart := false
@export var target: Node2D

var _elapsed := 0.0
var _wave_index := -1
var _enemy_index := 0
var _is_running := false
var _wave_start_times: Array[float] = []

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_elapsed = 0.0
	_wave_index = -1
	_enemy_index = 0
	_is_running = true
	
	# Pre-calculate all wave start times
	_wave_start_times.clear()
	var current_time = 0.0
	for i in range(waves.size()):
		_wave_start_times.append(current_time)
		if i < waves.size() - 1: # Not the last wave
			var wave = waves[i]
			current_time += (wave.count - 1) * wave.interval + wave_delay
	
	# Start the first wave
	if waves.size() > 0:
		_spawn_next_wave()

func _process(delta: float) -> void:
	if not _is_running:
		return
		
	_elapsed += delta
		
	while _wave_index < waves.size():
		var wave = waves[_wave_index]
		
		# Get the scheduled start time for this wave
		var start_time = 0.0
		if _wave_index >= 0 and _wave_index < _wave_start_times.size():
			start_time = _wave_start_times[_wave_index]
		else:
			# Calculate start time if not yet calculated
			start_time = _calculate_wave_start_time(_wave_index)
		
		var enemy_spawn_time = start_time + (_enemy_index * wave.interval)
		
		if _elapsed >= enemy_spawn_time:
			# Spawn the enemy
			_spawn_enemy(wave)
			
			# Check if this was the last enemy in the wave
			if _enemy_index == wave.count - 1:
				# Wave finished
				wave_finished.emit(_wave_index)
				
				# Check if this is the last wave
				if _wave_index == waves.size() - 1:
					all_waves_finished.emit()
					_is_running = false
					return
					
				# Move to next wave
				_wave_index += 1
				_enemy_index = 0
			else:
				# Increment enemy index for this wave
				_enemy_index += 1
		else:
			break

func _spawn_enemy(wave: WaveConfig) -> void:
	if wave.enemy_scene != null:
		var enemy = wave.enemy_scene.instantiate()
		if enemy is Node2D:
			add_child(enemy)
			if target != null and "target" in enemy:
				enemy.target = target

func _calculate_wave_start_time(wave_index: int) -> float:
	if wave_index < 0:
		return 0.0
	
	var start_time = 0.0
	for i in range(wave_index):
		var wave = waves[i]
		start_time += (wave.count - 1) * wave.interval + wave_delay
		
	return start_time

func _spawn_next_wave() -> void:
	if _wave_index < waves.size() - 1:
		_wave_index += 1
		_enemy_index = 0
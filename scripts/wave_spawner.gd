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
var _enemy_index := -1
var _is_running := false
var _wave_start_times: Array[float] = []

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_elapsed = 0.0
	_wave_index = -1
	_enemy_index = -1
	_is_running = true
	_wave_start_times.clear()
	
	# Calculate wave start times based on the timing rules
	var current_time = 0.0
	for i in range(waves.size()):
		_wave_start_times.append(current_time)
		if i < waves.size() - 1:  # Not the last wave
			var wave = waves[i]
			# Next wave starts after all enemies of this wave are spawned + wave_delay
			current_time += (wave.count - 1) * wave.interval + wave_delay

func _process(delta: float) -> void:
	if not _is_running:
		return
		
	_elapsed += delta
		
	# Spawn enemies that should be spawned at this time
	while true:
		var current_wave = _get_current_wave()
		
		# If we're past the last wave, stop
		if current_wave == null:
			_is_running = false
			emit_signal("all_waves_finished")
			return
			
		# Check if it's time to spawn an enemy for this wave
		var spawn_time = _get_spawn_time_for_current_wave()
		
		if _elapsed >= spawn_time:
			# Spawn the enemy
			_enemy_index += 1
			
			# If we've spawned all enemies for this wave, move to next wave
			if _enemy_index >= current_wave.count:
				# Move to next wave
				_wave_index += 1
				_enemy_index = -1
				
				emit_signal("wave_finished", _wave_index)
				
				# Check if this was the last wave
				if _wave_index >= waves.size() - 1:
					_is_running = false
					emit_signal("all_waves_finished")
					return
				
				continue
				
			# Spawn the enemy
			var enemy = current_wave.enemy_scene.instantiate()
			add_child(enemy)
			enemy.position = Vector2.ZERO
			
			# Set target if the enemy has a target property and we have a target
			if target != null and enemy.has_method("set_target"):
				enemy.set_target(target)
			elif target != null and enemy.has("target"):
				enemy.target = target
				
		else:
			# No more enemies to spawn for now
			break

func _get_current_wave() -> WaveConfig:
	if _wave_index < 0:
		return waves[0] if waves.size() > 0 else null
		
	if _wave_index >= waves.size():
		return null
		
	return waves[_wave_index]

func _get_spawn_time_for_current_wave() -> float:
	var current_wave = _get_current_wave()
	if current_wave == null:
		return inf
		
	# Get the start time of this wave
	var wave_start_time = 0.0
	if _wave_index >= 0 and _wave_index < _wave_start_times.size():
		wave_start_time = _wave_start_times[_wave_index]
	
	# Return the scheduled spawn time for this enemy in this wave
	return wave_start_time + (_enemy_index * current_wave.interval)
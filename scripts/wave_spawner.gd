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
	_wave_start_times.clear()
	
	# Pre-calculate all wave start times
	var current_time = 0.0
	for i in range(waves.size()):
		_wave_start_times.append(current_time)
		if i < waves.size() - 1:  # Not the last wave
			var prev_wave = waves[i]
			current_time += (prev_wave.count - 1) * prev_wave.interval + wave_delay

func _process(delta: float) -> void:
	if not _is_running:
		return
	
	_elapsed += delta
	
	# Spawn enemies until we're past the current scheduled time
	while _wave_index < waves.size() - 1 or _enemy_index < waves[_wave_index].count:
		var next_spawn_time = _get_next_spawn_time()
		
		if next_spawn_time <= _elapsed:
			_spawn_enemy()
			_enemy_index += 1
			
			# Check if this wave is finished
			if _enemy_index >= waves[_wave_index].count:
				wave_finished.emit(_wave_index)
				_advance_wave()
				
				# Check if all waves are finished
				if _wave_index >= waves.size() - 1:
					all_waves_finished.emit()
					_is_running = false
					break
		else:
			break

func _get_next_spawn_time() -> float:
	if _wave_index < 0 or _wave_index >= _wave_start_times.size():
		return 0.0
	
	var wave = waves[_wave_index]
	return _wave_start_times[_wave_index] + (_enemy_index * wave.interval)

func _advance_wave() -> void:
	if _wave_index < waves.size() - 1:
		_wave_index += 1
		_enemy_index = 0

func _spawn_enemy() -> void:
	if _wave_index < 0 or _wave_index >= waves.size():
		return
	
	var wave = waves[_wave_index]
	if not wave.enemy_scene:
		return
	
	var enemy = wave.enemy_scene.instantiate()
	add_child(enemy)
	
	# Set the target if it exists and the enemy has a target property
	if target and enemy.has_method("set_target"):
		enemy.set_target(target)
	elif target and enemy.has_field("target"):
		enemy.target = target
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

func start() -> void:
	_elapsed = 0.0
	_wave_index = -1
	_enemy_index = 0
	_is_running = true
	_spawn_next_wave()

func _ready() -> void:
	if autostart:
		start()

func _process(delta: float) -> void:
	if not _is_running:
		return
	
	_elapsed += delta
	
	# Check if we need to start the next wave
	while _wave_index < waves.size() - 1:
		var next_wave_start_time = _get_wave_start_time(_wave_index + 1)
		
		if _elapsed >= next_wave_start_time:
			_spawn_next_wave()
		else:
			break
	
	# Spawn enemies for current wave
	_spawn_enemies()

func _spawn_next_wave() -> void:
	_wave_index += 1
	_enemy_index = 0
	
	# If we've finished all waves, emit signals and stop
	if _wave_index >= waves.size():
		emit_signal("all_waves_finished")
		_is_running = false
		return

func _spawn_enemies() -> void:
	if _wave_index < 0 or _wave_index >= waves.size():
		return
		
	var wave = waves[_wave_index]
	var start_time = _get_wave_start_time(_wave_index)
	
	while _enemy_index < wave.count and _elapsed >= start_time + _enemy_index * wave.interval:
		var enemy = wave.enemy_scene.instantiate()
		add_child(enemy)
		
		if target != null and enemy.has_method("set_target"):
			enemy.set_target(target)
		elif target != null and enemy.has_field("target"):
			enemy.target = target
			
		_enemy_index += 1
		
		# If this is the last enemy of the wave, emit wave_finished signal
		if _enemy_index == wave.count:
			emit_signal("wave_finished", _wave_index)
			# Check if we're at the last wave
			if _wave_index == waves.size() - 1:
				emit_signal("all_waves_finished")
				_is_running = false

func _get_wave_start_time(wave_index: int) -> float:
	var start_time := 0.0
	
	for i in range(wave_index):
		var wave = waves[i]
		start_time += (wave.count - 1) * wave.interval + wave_delay
	
	return start_time
class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0
@export var autostart := false
@export var target: Node2D

var _elapsed := 0.0
var _started := false
var _next_wave_idx := 0
var _next_enemy_idx := 0

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_elapsed = 0.0
	_started = true
	_next_wave_idx = 0
	_next_enemy_idx = 0

func _process(delta: float) -> void:
	if not _started:
		return
	
	_elapsed += delta
	
	while _next_wave_idx < waves.size():
		var wave = waves[_next_wave_idx]
		var wave_start_time = _get_wave_start_time(_next_wave_idx)
		var enemy_scheduled_time = wave_start_time + _next_enemy_idx * wave.interval
		
		if _elapsed >= enemy_scheduled_time:
			_spawn_enemy(wave)
			_next_enemy_idx += 1
			
			if _next_enemy_idx >= wave.count:
				_next_enemy_idx = 0
				_next_wave_idx += 1
				wave_finished(_next_wave_idx - 1)
				
				if _next_wave_idx >= waves.size():
					all_waves_finished.emit()
					_started = false
					return
		else:
			break

func _get_wave_start_time(wave_idx: int) -> float:
	var time := 0.0
	for i in range(wave_idx):
		time += (waves[i].count - 1) * waves[i].interval
		time += wave_delay
	return time

func _spawn_enemy(wave: WaveConfig) -> void:
	var enemy = wave.enemy_scene.instantiate()
	add_child(enemy)
	if target != null and enemy.has("target"):
		enemy.target = target
class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0
@export var autostart := false
@export var target: Node2D

var _elapsed := 0.0
var _current_wave := 0
var _current_enemy := 0
var _started := false
var _finished := false

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_elapsed = 0.0
	_current_wave = 0
	_current_enemy = 0
	_started = true
	_finished = false

func _process(delta: float) -> void:
	if not _started or _finished:
		return
	
	_elapsed += delta
	
	while _current_wave < waves.size():
		var wave = waves[_current_wave]
		var scheduled_time = _get_scheduled_time(_current_wave, _current_enemy)
		
		if _elapsed >= scheduled_time:
			_spawn_enemy(wave)
			_current_enemy += 1
			
			if _current_enemy >= wave.count:
				emit_signal("wave_finished", _current_wave)
				_current_wave += 1
				_current_enemy = 0
				
				if _current_wave >= waves.size():
					emit_signal("all_waves_finished")
					_finished = true
					return
		else:
			break

func _get_scheduled_time(wave_index: int, enemy_index: int) -> float:
	var start_time := 0.0
	for i in range(wave_index):
		start_time += (waves[i].count - 1) * waves[i].interval + wave_delay
	
	return start_time + enemy_index * waves[wave_index].interval

func _spawn_enemy(wave: WaveConfig) -> void:
	if wave.enemy_scene == null:
		return
	
	var enemy = wave.enemy_scene.instantiate()
	add_child(enemy)
	
	if target != null and enemy.has("target"):
		enemy.target = target
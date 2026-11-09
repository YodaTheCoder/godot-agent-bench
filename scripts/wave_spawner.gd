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
var _enemy_index := 0
var _started := false
var _finished := false

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	if waves.is_empty():
		return
	_elapsed = 0.0
	_current_wave = 0
	_enemy_index = 0
	_started = true
	_finished = false

func _process(delta: float) -> void:
	if not _started or _finished:
		return

	_elapsed += delta

	while _current_wave < waves.size():
		var wave = waves[_current_wave]
		var scheduled_time = _get_wave_start_time(_current_wave) + _enemy_index * wave.interval

		if scheduled_time <= _elapsed:
			_spawn_enemy(wave)
			_enemy_index += 1

			if _enemy_index >= wave.count:
				emit_signal("wave_finished", _current_wave)
				_current_wave += 1
				_enemy_index = 0

				if _current_wave >= waves.size():
					emit_signal("all_waves_finished")
					_finished = true
		else:
			break

func _get_wave_start_time(wave_index: int) -> float:
	if wave_index == 0:
		return 0.0
	
	var time := 0.0
	for i in range(wave_index):
		time += (waves[i].count - 1) * waves[i].interval + wave_delay
	return time

func _spawn_enemy(wave: WaveConfig) -> void:
	var enemy = wave.enemy_scene.instantiate()
	add_child(enemy)
	if target != null and enemy.has_property("target"):
		enemy.target = target
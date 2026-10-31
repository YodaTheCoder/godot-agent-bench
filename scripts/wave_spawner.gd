class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0
@export var autostart := false
@export var target: Node2D

var _running := false
var _elapsed := 0.0
var _wave_index := 0
var _enemy_index := 0
var _wave_start := 0.0


func _ready() -> void:
	if autostart:
		start()


func start() -> void:
	_running = true
	_elapsed = 0.0
	_wave_index = 0
	_enemy_index = 0
	_wave_start = 0.0


func _process(delta: float) -> void:
	if not _running:
		return
	_elapsed += delta
	while _running and _next_spawn_time() <= _elapsed:
		_spawn_next()


func _next_spawn_time() -> float:
	return _wave_start + _enemy_index * waves[_wave_index].interval


func _spawn_next() -> void:
	var wave := waves[_wave_index]
	var enemy := wave.enemy_scene.instantiate()
	if target != null and "target" in enemy:
		enemy.set("target", target)
	add_child(enemy)
	_enemy_index += 1
	if _enemy_index < wave.count:
		return
	wave_finished.emit(_wave_index)
	if _wave_index == waves.size() - 1:
		_running = false
		all_waves_finished.emit()
		return
	_wave_start += (wave.count - 1) * wave.interval + wave_delay
	_wave_index += 1
	_enemy_index = 0

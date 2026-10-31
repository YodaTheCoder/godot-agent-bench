class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
## Seconds between the last spawn of a wave and the first spawn of the next one.
@export var wave_delay := 2.0
## Call start() from _ready().
@export var autostart := false
## Assigned to the `target` of each spawned enemy (when set and the enemy has one).
@export var target: Node2D

var _running := false
var _elapsed := 0.0
var _wave := 0
var _spawned_in_wave := 0
var _wave_start := 0.0


func _ready() -> void:
	if autostart:
		start()


func start() -> void:
	_running = not waves.is_empty()
	_elapsed = 0.0
	_wave = 0
	_spawned_in_wave = 0
	_wave_start = 0.0


func _process(delta: float) -> void:
	if not _running:
		return
	_elapsed += delta
	while _running:
		var config := waves[_wave]
		var due := _wave_start + _spawned_in_wave * config.interval
		if due > _elapsed:
			return
		_spawn(config)
		_spawned_in_wave += 1
		if _spawned_in_wave >= config.count:
			var finished := _wave
			_wave_start = due + wave_delay
			_wave += 1
			_spawned_in_wave = 0
			wave_finished.emit(finished)
			if _wave >= waves.size():
				_running = false
				all_waves_finished.emit()


func _spawn(config: WaveConfig) -> void:
	var enemy := config.enemy_scene.instantiate()
	if target != null and "target" in enemy:
		enemy.target = target
	add_child(enemy)

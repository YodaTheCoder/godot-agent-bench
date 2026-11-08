class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0   # float, seconds
@export var autostart := false
@export var target: Node2D

var _wave_index := -1
var _next_spawn_time := 0.0
var _elapsed := 0.0
var _active := false
var _spawned_count := 0

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_wave_index = -1
	_next_spawn_time = 0.0
	_elapsed = 0.0
	_active = true
	_spawned_count = 0
	
	# Reset all children that are enemies to avoid duplicate spawns
	for child in get_children():
		if child is Enemy:
			child.queue_free()

func _process(delta: float) -> void:
	if not _active:
		return
		
	_elapsed += delta
	
	# Check if we need to start a new wave
	if _wave_index < 0 or _spawned_count >= waves[_wave_index].count:
		_wave_index += 1
		_spawned_count = 0
		
		if _wave_index >= waves.size():
			emit_signal("all_waves_finished")
			_active = false
			return
			
		# Initialize the next wave's spawn time
		_next_spawn_time = _wave_index == 0 ? 0.0 : \
			_next_spawn_time + (waves[_wave_index - 1].count - 1) * waves[_wave_index - 1].interval + wave_delay
	
	while _active and _spawned_count < waves[_wave_index].count:
		var spawn_time = _next_spawn_time + _spawned_count * waves[_wave_index].interval
		if _elapsed >= spawn_time:
			spawn_enemy()
		else:
			break

func spawn_enemy() -> void:
	var enemy = waves[_wave_index].enemy_scene.instantiate()
	add_child(enemy)
	enemy.position = Vector2.ZERO
	
	if target != null:
		enemy.target = target
	
	_spawned_count += 1
	
	# Check if this was the last enemy of the current wave
	if _spawned_count >= waves[_wave_index].count:
		emit_signal("wave_finished", _wave_index)
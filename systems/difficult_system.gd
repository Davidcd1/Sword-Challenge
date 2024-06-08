extends Node

@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 60
@export var spawn_rate_per_minute: float = 30
@export var wave_duration: float = 30
@export var break_intensity: float = 0.5

var time: float = 0.0
var game_over: bool = false

func _process(delta: float) -> void:
	if game_over == true: 
		self.queue_free()
	if GameManager.game_over: game_over = true
	
	# Incrementar temporizador
	time += delta
	
	# Dificuldade Linear (linha verde)
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time / 60)
	
	# Sistema de ondas (Linha rosa)
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
	spawn_rate += wave_factor
	
	#Aplicar dificuldade
	
	mob_spawner.mobs_per_minute = spawn_rate

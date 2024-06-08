extends Node

# ID da fase
@export var phase_id: int = -1
@export var phase_kills: int

func _ready():
	GameManager.current_phase = phase_id
	GameManager.leveis[phase_id] = phase_kills

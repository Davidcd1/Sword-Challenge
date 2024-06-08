extends Node

# Player
var player: Player
var player_position: Vector2

# Enemy
var enemy: Enemy

# Scenes Manager
var smanager: SceneManager
var current_phase: int = -1

# UI
var kills: int
var time: String 
var meats: int
var time_elapsed: float

var pause: bool = true

# Level
var leveis: Array[int] = [
	1,
	2,
	3,
	3
]
var total_time_elapsed: float
var total_time: String
var total_kills: int
var total_meats: int

# Game Over
var game_over: bool = false

func _ready():
	if player:
		player.meat_collected.connect(on_meat_collected)
	else:
		print("GameManager.player is null")
	
	# Atribuir o singleton smanager
	# smanager = get_node("/root/ScenesManager")
	
func _process(delta):
	if pause == false:
		update_timer(delta)
	
# Atualiza o timer
func update_timer(delta: float):
	time_elapsed += delta
	total_time_elapsed += delta
	# Tempo da fase
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60
	time = str("%02d:%02d" % [minutes, seconds])
		
# Atualiza os abates do jogador
func on_killed():
	print(total_time)
	total_kills += 1
	kills += 1
	next_level()
# Atualiza a carne coletada
func on_meat_collected():
	total_meats += 1
	meats += 1
# Instancia o GameOver
func on_game_over():
	game_over = true
	pause = true
	# Adiciona a cena instanciada ao nó pai desejado
	var game_over_prefab = smanager.game_over_ui.instantiate()
	var main_node = get_tree().root.get_node("Main")
	main_node.add_child(game_over_prefab)
	
func next_level():
	var level: int
	if kills >= leveis[current_phase]:
		level = current_phase+1
	else: return
	
	pause = false
	change_current_scene(smanager.fases[level], 1)

# Muda para a nova cena
func change_current_scene(scene_path: String, nivel: int = 0):
	if nivel >= 1:
		kills = 0
		time = "00:00"
		time_elapsed = 0.0
		meats = 0
	get_tree().change_scene_to_file(scene_path)
		


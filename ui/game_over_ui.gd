extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var monsters_label: Label = %MonstersLabel

var time_survived: String
var monsters_defeated: int

func _ready():
	time_label.text = str(GameManager.time)
	monsters_label.text = str(GameManager.kills)


func main_menu_button():
	GameManager.game_over = false
	# Volta para o Menu Principal
	var menu: String = str(GameManager.smanager.main_menu)
	GameManager.change_current_scene(menu)

func restart_game():
	GameManager.pause = false
	GameManager.game_over = false
	# Reinicia a fase
	var fase_atual = str(GameManager.smanager.fases[GameManager.current_phase])
	GameManager.change_current_scene(fase_atual, 1)
	

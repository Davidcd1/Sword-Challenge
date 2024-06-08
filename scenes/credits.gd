extends Panel

@onready var time: Label = %time_played
@onready var kills: Label = %enemies_defeated
@onready var meats: Label = %meats_collected

@onready var congrats: CanvasLayer = %Congrat
@onready var credits: Label = %credits

@onready var next: bool = false
@onready var next_btn: Button = %next_btn
@onready var back_btn: Button = %back_btn

@onready var time_elapsed_in_seconds: int = floori(GameManager.total_time_elapsed)

func _ready():
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60
	GameManager.total_time = str("%02d:%02d" % [minutes, seconds])

	time.text = str(GameManager.total_time)
	kills.text = str(GameManager.total_kills)
	meats.text = str(GameManager.total_meats)

func _on_next_pressed():
	if next == false:
		credits.show()
		back_btn.show()
		next_btn.text = "Main Menu"
		next = true
		congrats.hide()
	else:
		GameManager.total_time_elapsed = 0
		GameManager.total_time = "00:00"
		GameManager.total_kills = 0
		GameManager.total_meats = 0
		GameManager.change_current_scene(GameManager.smanager.main_menu, 1)


func _on_back_pressed():
	if next == true:
		congrats.show()
		next = false
		next_btn.text = "Next"
		credits.hide()
		back_btn.hide()

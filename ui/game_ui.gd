extends CanvasLayer

@onready var time_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel
@onready var kills_label: Label = %KillsLabel
@onready var fase_kills: Label = %FaseKillsLabel

func _process(delta: float):
	kills_label.text = str(GameManager.kills)
	meat_label.text = str(GameManager.meats)
	time_label.text = str(GameManager.time)
	fase_kills.text = str(GameManager.leveis[GameManager.current_phase])
	
	if GameManager.game_over == true:
		queue_free()
	

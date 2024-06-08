extends Control



func _on_start_btn_pressed():
	var scene = str(GameManager.smanager.fases[0])
	GameManager.pause = false
	GameManager.change_current_scene(scene)
	
func _on_quit_btn_pressed():
	get_tree().quit()

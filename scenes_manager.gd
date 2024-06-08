extends Node

# fases
var fases: Array[String] = [
	"res://scenes/fases/fase1.tscn",
	"res://scenes/fases/fase2.tscn",
	"res://scenes/fases/fase3.tscn",
	"res://scenes/credits.tscn"
]
				
var main_menu: String = "res://scenes/main_menu.tscn"

var game_over_ui: PackedScene = preload("res://ui/game_over_ui.tscn")

func _ready():
	GameManager.smanager = self

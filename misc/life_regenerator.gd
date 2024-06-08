extends Node2D

@export var regeneration_amount: float = 1

var area2d: Area2D 

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
	
func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(player.max_health*regeneration_amount)
		GameManager.on_meat_collected()
		queue_free()

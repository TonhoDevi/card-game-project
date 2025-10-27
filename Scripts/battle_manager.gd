extends Node

@onready var player_hand: Node2D = $"../PlayerHand"
@onready var opponent_hand: Node2D = $"../OpponentHand"

var universal_player_buff : float = 1.0
var universal_opponent_buff : float = 1.0


func apply_universal_buff(card: Node2D) -> float:
	return 2.0
	
func attack(card : Node2D, target : Node2D, type : String)-> void:
	var damage : float = float(card.get_attack())
	target.set_health(-damage, -damage, type)
	

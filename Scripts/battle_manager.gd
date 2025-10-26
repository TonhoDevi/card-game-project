extends Node

@onready var end_turno_ref: Button = $"../Control/EndTurno"
@onready var battle_timer_ref: Timer = $"BattleTimer"
@onready var opponent_hand_ref: Node2D = $"../OpponentHand"
@onready var opponent_ia_ref: Node2D = $"../OpponentIA"
@export var wait_time: float = 1.0
var empty_heros_card_slot: Array = []
var empty_magic_card_slot: Array = []
var player_can_play: bool = true

# Called when the node enters the scene tree for the first time.

func _on_end_turno_pressed() -> void:
	opponent_turn()
	player_can_play = false	
	

func end_opponent_turn() -> void:
	end_turno_ref.disabled = false
	end_turno_ref.visible = true
	player_can_play = true


func opponent_turn() -> void:
	end_turno_ref.disabled = true
	end_turno_ref.visible = false
	battle_timer_ref.start(wait_time)
	await battle_timer_ref.timeout
	opponent_ia_ref.start_turn()

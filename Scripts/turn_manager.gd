extends Node

@onready var end_turno_ref: Button = $"../Control/EndTurno"
@onready var turn_timer_ref: Timer = $"TurnTimer"
@onready var player_hand_ref: Node2D = $"../PlayerHand"
@onready var input_manager_ref: Node2D = $"../InputManager"
@onready var opponent_hand_ref: Node2D = $"../OpponentHand"
@onready var opponent_ia_ref: Node2D = $"../OpponentIA"
@export var wait_time: float = 1.0
var empty_heroes_card_slot: Array = []
var empty_magic_card_slot: Array = []

# Called when the node enters the scene tree for the first time.

func _on_end_turno_pressed() -> void:
	opponent_preparation_turn()
	
func opponent_preparation_turn() -> void:
	end_turno_ref.disabled = true
	end_turno_ref.visible = false
	input_manager_ref.change_game_phase("CombatTurn")
	turn_timer_ref.start(wait_time)
	await turn_timer_ref.timeout
	opponent_ia_ref.start_preparation_turn()

func end_opponent_preparation_turn() -> void:
	start_player_combat_turn()

func start_player_combat_turn() -> void:
	end_turno_ref.disabled = true
	end_turno_ref.modulate = Color.RED
	end_turno_ref.visible = true
	turn_timer_ref.start(wait_time)
	await turn_timer_ref.timeout
	opponent_ia_ref.start_combat_turn()

func end_opponent_combat_turn() -> void:
	end_turno_ref.disabled = false
	end_turno_ref.visible = true
	end_turno_ref.modulate = Color.WHITE
	input_manager_ref.change_game_phase("PreparationTurn")

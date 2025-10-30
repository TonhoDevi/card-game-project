extends Node

@onready var turn_name: RichTextLabel = $"../Control/TurnName"
@onready var end_turno_ref: Button = $"../Control/EndTurno"
@onready var turn_timer_ref: Timer = $"TurnTimer"
@onready var player_hand_ref: Node2D = $"../PlayerHand"
@onready var input_manager_ref: Node2D = $"../InputManager"
@onready var opponent_hand_ref: Node2D = $"../OpponentHand"
@onready var opponent_ia_ref: Node2D = $"../OpponentIA"
@export var wait_time: float = 1.0
@onready var game_phase: String = "preparation_phase"
@onready var user_turn : String = "Player preparation turn"

# Called when the node enters the scene tree for the first time.

func _on_end_turno_pressed() -> void:
	if game_phase == "preparation_phase":
		start_opponent_preparation_turn()
		game_phase =  "combat_phase"
		end_turn_active_button(false)
	elif game_phase == "combat_phase":
		start_opponent_combat_turn()
		game_phase =  "preparation_phase"
		end_turn_active_button(false)
	
func start_opponent_preparation_turn() -> void:
	define_visual_turn("Opponent preparation turn", false)
	turn_timer_ref.start(wait_time)
	await turn_timer_ref.timeout
	opponent_ia_ref.start_preparation_turn()

func end_opponent_preparation_turn() -> void:
	input_manager_ref.change_game_phase("combat_phase")
	end_turn_active_button(true)
	start_player_combat_turn()
	
func start_opponent_combat_turn():
	define_visual_turn("Opponent combat turn", false)
	turn_timer_ref.start(wait_time)
	await turn_timer_ref.timeout
	opponent_ia_ref.start_combat_turn()

func end_opponent_combat_turn() -> void:
	input_manager_ref.change_game_phase("preparation_phase")
	turn_timer_ref.start(wait_time)
	await turn_timer_ref.timeout
	start_player_preparation_turn()

func start_player_preparation_turn():
	end_turn_active_button(true)
	define_visual_turn("Player preparation turn", true)
	
func end_player_preparation_turn():
	pass
	
func start_player_combat_turn() -> void:
	define_visual_turn("Player combat turn", true)
	turn_timer_ref.start(wait_time)
	await turn_timer_ref.timeout

func end_player_combat_turn():
	pass


func end_turn_active_button(trigger : bool) -> void :
	end_turno_ref.disabled = !trigger
	end_turno_ref.visible = trigger

func define_visual_turn(description : String, trigger: bool) -> void :
	user_turn = description
	turn_name.text = description
	if trigger:
		turn_name.self_modulate = Color.WHITE
	else: 
		turn_name.self_modulate = Color.RED

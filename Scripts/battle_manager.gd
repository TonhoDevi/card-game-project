extends Node

@onready var end_turno: Button = $"../Control/EndTurno"
@onready var opponent_card_deck: Node2D = $"../OpponentCardDeck"
@onready var battle_timer: Timer = $BattleTimer
@onready var opponent_table: Node2D = $"../OpponentTable"
@onready var opponent_hand: Node2D = $"../OpponentHand"
@export var wait_time: float = 1.0
var empty_heros_card_slot: Array = []
var empty_magic_card_slot: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_timer.one_shot = true
	battle_timer.wait_time = wait_time
	

func get_all_slots_without_cards_heros() -> Node2D:
	empty_heros_card_slot.clear()
	var opponent_magic_table = opponent_table.get_child(0)
	for slot in opponent_magic_table.get_children():
		if not slot.card_in_slot:
			empty_heros_card_slot.append(slot)
	return empty_heros_card_slot[randi_range(0,empty_heros_card_slot.size()-1)]

func get_all_slots_without_cards_magic() -> Node2D:
	empty_magic_card_slot.clear()
	var opponent_magic_table = opponent_table.get_child(1)
	for slot in opponent_magic_table.get_children():
		if not slot.card_in_slot:
			empty_magic_card_slot.append(slot)
	return empty_magic_card_slot[randi_range(0,empty_magic_card_slot.size()-1)]

func _on_end_turno_pressed() -> void:
	opponent_turn()
	return	
	

func end_opponent_turn() -> void:
	get_all_slots_without_cards_heros()
	get_all_slots_without_cards_magic()
	end_turno.disabled = false
	end_turno.visible = true


func opponent_turn() -> void:
	end_turno.disabled = true
	end_turno.visible = false

	var hero_slot = get_all_slots_without_cards_heros()
	var magic_slot = get_all_slots_without_cards_magic()
	battle_timer.start()
	await battle_timer.timeout
	# Draw Cards
	if opponent_card_deck.opponent_deck.size() == 0:
		end_opponent_turn()
		return 
	opponent_card_deck.draw_deck()
	
	if opponent_hand.opponent_hand.size() == 0:
		end_opponent_turn()
		return

	
	if empty_heros_card_slot.size() == 0:
		end_opponent_turn()
		return
	if empty_magic_card_slot.size() == 0:
		end_opponent_turn()
		return
	
	end_opponent_turn()

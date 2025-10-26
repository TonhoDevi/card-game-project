extends Node2D
@onready var opponent_hand_ref: Node2D = $"../OpponentHand"
@onready var opponent_table_ref: Node2D = $"../OpponentTable"
@onready var opponent_card_deck_ref: Node2D = $"../OpponentCardDeck"
@onready var battle_manager_ref: Node = $"../BattleManager"
@onready var timer: Timer = $"Timer"
@export var wait_time_between_actions: float = 0.75
var vci_ref = preload("res://Scripts/visual_card_interaction.gd").new() 

# ============= Turn Logic =============
func start_turn() -> void:
	# Buy a card from deck
	buy_card_from_deck()
	#
	timer.start(wait_time_between_actions)
	await timer.timeout
	# Check for free slots to play
	if get_free_hero_slot():
		# Play a hero card
		var hero_card = opponent_hand_ref.get_random_hero_card()
		var hero_slot = get_free_hero_slot()
		if hero_card and hero_slot:
			play_hero_card(hero_card, hero_slot)

	elif get_free_magic_slot():
		# Play a magic card
		var magic_card = opponent_hand_ref.get_random_magic_card()
		var magic_slot = get_free_magic_slot()
		if magic_card and magic_slot:
			play_magic_card(magic_card, magic_slot)
	# End turn
	timer.start(wait_time_between_actions/2)
	await timer.timeout
	end_turn()
	

func end_turn() -> void:
	battle_manager_ref.end_opponent_turn()


#=============  Move Card Actions =============

func buy_card_from_deck() -> void:
	if opponent_card_deck_ref.opponent_deck.size() == 0:
		return 
	opponent_card_deck_ref.draw_deck()

func get_free_magic_slot() -> Node2D:
	var magic_table : Node = opponent_table_ref.get_child(0)
	for slot in magic_table.get_children(): 
		if slot.card_in_slot == false:
			return slot
	return null

func get_free_hero_slot() -> Node2D:
	var hero_table : Node = opponent_table_ref.get_child(1)
	for slot in hero_table.get_children(): 
		if slot.card_in_slot == false:
			return slot
	return null

func play_magic_card(card_node: Node2D, slot_node: Node2D) -> void:
	opponent_hand_ref.remove_card_from_hand(card_node)
	slot_node.card_in_slot = true
	card_node.card_slot_card_is_in = slot_node
	card_node.get_node("AnimationPlayer").play("card_flip")
	opponent_hand_ref.animate_card_to_position(card_node, slot_node.position)
	vci_ref.minimize_card(card_node)

func play_hero_card(card_node: Node2D, slot_node: Node2D) -> void:
	opponent_hand_ref.remove_card_from_hand(card_node)
	slot_node.card_in_slot = true
	card_node.card_slot_card_is_in = slot_node
	card_node.get_node("AnimationPlayer").play("card_flip")
	opponent_hand_ref.animate_card_to_position(card_node, slot_node.position)
	vci_ref.minimize_card(card_node)


# ============== Combat Logic ==============
func perform_attack(attacker_card: Node2D, target_card: Node2D) -> void:
	# Animate attack
	vci_ref.animate_card_attack(attacker_card, target_card.position)
	await vci_ref.animation_completed
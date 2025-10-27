extends Node2D
@onready var opponent_hand_ref: Node2D = $"../OpponentHand"
@onready var opponent_table_ref: Node2D = $"../OpponentTable"
@onready var opponent_card_deck_ref: Node2D = $"../OpponentCardDeck"
@onready var battle_manager_ref: Node = $"../BattleManager"
@onready var player_table_ref: Node2D = $"../PlayerTable"
@onready var visual_manager: Node2D = $"../CardManager/VisualManager"


@onready var timer: Timer = $"Timer"
@export var wait_time_between_actions: float = 0.75

# ============= Preparation Turn Logic =============
func start_preparation_turn() -> void:
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
	end_preparation_turn()
	

func end_preparation_turn() -> void:
	battle_manager_ref.end_opponent_preparation_turn()



# ============= Combat Turn Logic =============


func start_combat_turn() -> void:
	var attacker_card : Node2D = chose_card_to_attack()
	if attacker_card == null:
		end_combat_turn()
		return
	var target_card : Node2D = chose_attack_target()
	if target_card == null:
		end_combat_turn()
		return
	perform_attack(attacker_card, target_card)
	timer.start(wait_time_between_actions)
	await timer.timeout
	end_combat_turn()

func end_combat_turn() -> void:
	battle_manager_ref.end_opponent_combat_turn()

	
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
	slot_node.card_in_slot_ref = card_node
	card_node.card_slot_card_is_in = slot_node
	card_node.get_node("AnimationPlayer").play("card_flip")
	opponent_hand_ref.animate_card_to_position(card_node, slot_node.position)
	visual_manager.minimize_card(card_node)

func play_hero_card(card_node: Node2D, slot_node: Node2D) -> void:
	opponent_hand_ref.remove_card_from_hand(card_node)
	slot_node.card_in_slot = true
	slot_node.card_in_slot_ref = card_node
	card_node.card_slot_card_is_in = slot_node
	card_node.get_node("AnimationPlayer").play("card_flip")
	opponent_hand_ref.animate_card_to_position(card_node, slot_node.position)
	visual_manager.minimize_card(card_node)


# ============== Combat Logic ==============

func perform_attack(attacker_card: Node2D, target_card: Node2D) -> void:
	# Animate attack
	visual_manager.animate_card_attack(attacker_card, target_card.position)
	timer.start(wait_time_between_actions)
	await timer.timeout

func chose_attack_target() -> Node2D:
	var hero_table : Node = player_table_ref.get_child(1)
	var possible_targets : Array = []
	for slot in hero_table.get_children():
		if slot.card_in_slot:
			possible_targets.append(slot.card_in_slot_ref)
	if possible_targets.size() == 0:
		return null
	# Randomly select a target
	var random_index : int = randi_range(0, possible_targets.size() - 1)
	return possible_targets[random_index]

func chose_card_to_attack() -> Node2D:
	var hero_table : Node = opponent_table_ref.get_child(1)
	var possible_attackers : Array = []
	for slot in hero_table.get_children():
		if slot.card_in_slot:
			possible_attackers.append(slot.card_in_slot_ref) # Assuming the card is the first child
	if possible_attackers.size() == 0:
		return null
	# Randomly select an attacker
	var random_index : int = randi_range(0, possible_attackers.size() - 1)
	return possible_attackers[random_index]

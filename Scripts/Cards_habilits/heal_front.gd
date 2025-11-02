extends Node

func trigger(card : Node2D, player_manager : Node2D, opponent_ia : Node2D):
	for card_in_table in find_heroes_list(card,player_manager,opponent_ia):
		if find_slot(card_in_table).slot_num == find_slot(card).slot_num:
			card_in_table.heal_effect(5)

func user_type(card) -> bool:
	if card.card_user == "Player":
		return true
	elif card.card_user == "Opponent":
		return false
	else:
		return false

func find_heroes_list(card,player_manager,opponent_ia) -> Array:
	if user_type(card):
		return player_manager.player_table_ref.cards_on_hero_table
	else:
		return opponent_ia.opponent_table_ref.cards_on_hero_table
		
func find_magic_list(card,player_manager,opponent_ia) -> Array:
	if user_type(card):
		return player_manager.player_table_ref.cards_on_magic_table
	else:
		return opponent_ia.opponent_table_ref.cards_on_magic_table

func find_adversary_hero_table(card, player_manager, opponent_ia) -> Node:
	if user_type(card):
		return opponent_ia.opponent_table_ref.get_child(1)
	else:
		return player_manager.player_table_ref.get_child(1)

func find_adversary_magic_table(card, player_manager, opponent_ia) -> Node:
	if user_type(card):
		return opponent_ia.opponent_table_ref.get_child(0)
	else:
		return player_manager.player_table_ref.get_child(0)
		
func find_deck(card, player_manager, opponent_ia) -> Node2D:
	if user_type(card):
		return player_manager.player_card_deck_ref
	else:
		return opponent_ia.opponent_card_deck_ref

func find_mana_pool(card, player_manager, opponent_ia) -> Node2D:
	if user_type(card):
		return player_manager.player_mana_ref
	else:
		return opponent_ia.opponent_card_deck_ref

func find_slot(card) -> Node2D:
	return card.card_slot_ref

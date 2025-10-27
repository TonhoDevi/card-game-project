extends Node2D

const HAND_Y_POSITION : int = 100
const CARD_WIDTH : int = 150
const CARD_DRAW_SPEED : float = 0.7
var opponent_hand : Array = []
var centre_screen_x : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centre_screen_x = get_viewport().size.x * 2
	
func add_card_to_hand(card: Node2D):
	if card not in opponent_hand:
		opponent_hand.insert(0,card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.start_position)


func remove_card_from_hand(card: Node2D):
	if card in opponent_hand:
		opponent_hand.erase(card)
		update_hand_positions()
		


func update_hand_positions():
	var hand_size = opponent_hand.size()
	for i in range(hand_size):
		var new_position : Vector2 = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card : Node2D = opponent_hand[i]
		card.start_position = new_position
		animate_card_to_position(card,new_position)


func get_random_hero_card() -> Node2D:
	var hero_cards : Array = []
	for card in opponent_hand:
		if card.card_type == "Hero":
			hero_cards.append(card)
	if hero_cards.size() == 0:
		return null
	var random_index : int = randi_range(0, hero_cards.size()-1)
	return hero_cards[random_index]

func get_random_magic_card() -> Node2D:
	var magic_cards : Array = []
	for card in opponent_hand:
		if card.card_type == "Magic":
			magic_cards.append(card)
	if magic_cards.size() == 0:
		return null
	var random_index : int = randi_range(0, magic_cards.size()-1)
	return magic_cards[random_index]



func calculate_card_position(index: int) -> float:
	centre_screen_x = get_viewport().size.x / 2
	var total_cards : int = (opponent_hand.size() - 1) * CARD_WIDTH
	var x_offset : float = centre_screen_x - index * CARD_WIDTH + total_cards / 2.0
	return x_offset



func animate_card_to_position(card: Node2D, new_position: Vector2):
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, CARD_DRAW_SPEED)

extends Node2D

const HAND_CONT = 5
const HAND_Y_POSITION = 800
const CARD_WIDTH = 200
var player_hand = []
var centre_screen_x
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centre_screen_x = get_viewport().size.x / 2
	for i in range(HAND_CONT):
		var new_card = preload("res://Scenes/card.tscn").instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "Card_%d" % i
		add_card_to_hand(new_card)


func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.start_position)

func update_hand_positions():
	var hand_size = player_hand.size()
	for i in range(hand_size):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.start_position = new_position
		animate_card_to_position(card,new_position)


func calculate_card_position(index):
	var total_cards = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = centre_screen_x + index * CARD_WIDTH - total_cards / 2
	return x_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

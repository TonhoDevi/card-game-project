extends Node2D

const HAND_CONT = 2
const HAND_Y_POSITION = 600
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
	player_hand.insert(0,card)
	update_hand_positions()


func update_hand_positions():
	var hand_size = player_hand.size()
	for i in range(hand_size):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		animate_card_to_position(card,new_position)


func calculate_card_position(index):
	var total_cards = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = centre_screen_x + (index * CARD_WIDTH) - (total_cards / 2)
	return x_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1).set_transition(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

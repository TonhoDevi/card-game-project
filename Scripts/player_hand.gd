extends Node2D

const HAND_Y_POSITION : int = 975
const CARD_WIDTH : int = 150
const CARD_DRAW_SPEED : float = 0.75
var player_hand : Array = []
var centre_screen_x : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centre_screen_x = get_viewport().size.x / 2

func add_card_to_hand(card: Node2D):
	if card not in player_hand:
		player_hand.insert(0,card)
		card.get_node("Area2D").collision_mask = 1
		update_hand_positions()
	else:
		animate_card_to_position(card, card.start_position)

func remove_card_from_hand(card: Node2D):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()

func update_hand_positions():
	var hand_size = player_hand.size()
	for i in range(hand_size):
		var new_position : Vector2 = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card : Node2D = player_hand[i]
		card.start_position = new_position
		animate_card_to_position(card,new_position)


func calculate_card_position(index: int) -> float:
	var total_cards : int = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset : float = centre_screen_x + index * CARD_WIDTH - total_cards / 2.0
	return x_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate_card_to_position(card: Node2D, new_position: Vector2):
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, CARD_DRAW_SPEED)

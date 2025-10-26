extends Node

const BIG_SCALE_NODE : Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE_NODE : Vector2 = Vector2(0.85, 0.85)
const SMALL_SCALE_NODE : Vector2 = Vector2(0.7, 0.7)
# Connect card signals
func connect_card_signals(card: Node2D) -> void:
	card.connect("mouse_entered_card", on_card_mouse_entered)
	card.connect("mouse_exited_card", on_card_mouse_exited)

# Helper functions for card hovering
func on_card_mouse_entered(card: Node2D) -> void:
	if !card.card_slot_card_is_in:
		highlight_card(card,true)
	
# Helper functions for card hovering
func on_card_mouse_exited(card: Node2D) -> void:
	if !card.card_slot_card_is_in:
		highlight_card(card,false)

# Helper function to highlight cards
func highlight_card(card, hovering: bool):
	if hovering:
		card.scale = BIG_SCALE_NODE
		card.z_index = 2
		card.modulate = Color(1,1,1,1.2)
	else:
		card.scale = DEFAULT_SCALE_NODE
		card.z_index = 1
		card.modulate = Color(1,1,1,1)

func minimize_card(card):
	card.scale = SMALL_SCALE_NODE
	card.z_index = 0
	card.modulate = Color(1,1,1,1)

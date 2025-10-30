extends Node

const BIG_SCALE_NODE : Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE_NODE : Vector2 = Vector2(0.85, 0.85)
const SMALL_SCALE_NODE : Vector2 = Vector2(0.7, 0.7)
@onready var timer: Timer = $"Timer"
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
# Helper function to minimize card attack
func minimize_card(card):
	card.scale = SMALL_SCALE_NODE
	card.z_index = 0
	card.modulate = Color(1,1,1,1)

# Helper function to animate card attack
func animate_card_attack(card: Node2D, target_position: Vector2) -> void:
	card.z_index = 8
	var tween : Tween = get_tree().create_tween()
	var original_position : Vector2 = card.position
	var attack_position : Vector2 = target_position
	tween.tween_property(card, "position", attack_position, 0.25)
	timer.start(0.25)
	await timer.timeout
	var tween2 : Tween = get_tree().create_tween()
	tween2.tween_property(card, "position", original_position, 0.25)
	timer.start(0.25)
	await timer.timeout
	card.z_index = 0


func car_select(card : Node2D) -> void:
	card.emit_particles()

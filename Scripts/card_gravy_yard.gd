extends Node2D

@onready var timer: Timer = $Timer
@onready var opponent_hand: Node2D = $"../OpponentHand"
const CARD_DRAW_SPEED : float = 1.0
var gravy_yard : Array = []

# Called when the node enters the scene tree for the first time.


func add_card_to_gravy_yard(card: Node2D):
	if card not in gravy_yard:
		gravy_yard.insert(0,card)
		card.get_node("Area2D").collision_mask = 128
		animate_card_to_position(card)
		var slot = card.card_slot_card_is_in
		if slot:
			slot.card_in_slot = false
			slot.card_in_slot_ref = null
		card.card_slot_card_is_in = null
		


func remove_card_from_gravy_hard_to_hand(card: Node2D):
	if card in gravy_yard:
		gravy_yard.erase(card)
		opponent_hand.add_card_to_hand(card)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate_card_to_position(card: Node2D):
	timer.start(0.8)
	await timer.timeout
	card.get_node("AnimationPlayer").play_backwards("card_flip")
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(card, "position", position, CARD_DRAW_SPEED)
	

extends Node2D

var opponent_deck : Array = ["Pachorro", "Wargato", "Ranbara", "Roruja", "Pachorro", "Wargato", "Ranbara", "Roruja", "Pachorro", "Wargato"]
var card_data_ref
var STARTER_DECK_SIZE: int = 3

func _ready() -> void:
	opponent_deck.shuffle() #
	$Control/RichTextLabel.text = str(opponent_deck.size())
	card_data_ref = preload("res://Scripts/card_data_base.gd")
	for i in range(STARTER_DECK_SIZE):
		draw_deck()

func draw_deck():

	var card_drawn_name: String = opponent_deck[0]
	opponent_deck.erase(card_drawn_name)


	if opponent_deck.size() == 0:
		$Sprite2D.visible = false
		$Control/RichTextLabel.visible = false



	var new_card : Node = preload("res://Scenes/opponent_card.tscn").instantiate()
	new_card.global_position = global_position
	var card_image_path : String = "res://Assets/Cards/" + card_drawn_name + ".webp"
	new_card.get_node("Control/Attack").text = str(card_data_ref.CARD_DATA[card_drawn_name][0])
	new_card.get_node("Control/Health").text = str(card_data_ref.CARD_DATA[card_drawn_name][1])
	new_card.get_node("Control/ManaCost").text = str(card_data_ref.CARD_DATA[card_drawn_name][2])
	new_card.card_type = card_data_ref.CARD_DATA[card_drawn_name][3]
	new_card.get_node("CardImage").texture = load(card_image_path)

	$"../CardManager".add_child(new_card)
	new_card.name = "OpponentCard"
	$"../OpponentHand".add_card_to_hand(new_card)
	$Control/RichTextLabel.text = str(opponent_deck.size())

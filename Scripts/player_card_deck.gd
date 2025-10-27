extends Node2D

var player_deck : Array = ["Pachorro", "Wargato", "Ranbara", "Espirito_Protetor", "Orbe_Pirotecnica", "Estandarte_De_Cura", "Ranbara", "Wargato"]
var card_data_ref
var have_drawed_card: bool = false
var STARTER_DECK_SIZE: int = 3

func _ready() -> void:
	player_deck.shuffle() #
	$Control/RichTextLabel.text = str(player_deck.size())
	card_data_ref = preload("res://Scripts/universal_card_data_base.gd")
	for i in range(STARTER_DECK_SIZE):
		draw_deck()
		have_drawed_card = false
	have_drawed_card = true 

func draw_deck():
	# Prevent drawing multiple cards at once
	if have_drawed_card:
		return
	have_drawed_card = true
	# Draw the top card from the deck
	var card_drawn_name: String = player_deck[0]
	player_deck.erase(card_drawn_name)
	# Check if deck is empty
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$Control/RichTextLabel.visible = false
	# Create new card instance
	var new_card : Node = preload("res://Scenes/card.tscn").instantiate()
	new_card.global_position = global_position
	var card_image_path : String = "res://Assets/Cards/" + card_drawn_name + ".webp"
	new_card.get_node("Control/Attack").text = str(card_data_ref.CARD_DATA[card_drawn_name][0])
	new_card.get_node("Control/Health").text = str(card_data_ref.CARD_DATA[card_drawn_name][1])
	new_card.get_node("Control/ManaCost").text = str(card_data_ref.CARD_DATA[card_drawn_name][2])
	new_card.card_type = card_data_ref.CARD_DATA[card_drawn_name][3]
	new_card.get_node("CardImage").texture = load(card_image_path)
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	new_card.get_node("AnimationPlayer").play("card_flip")
	$"../PlayerHand".add_card_to_hand(new_card)
	$Control/RichTextLabel.text = str(player_deck.size())

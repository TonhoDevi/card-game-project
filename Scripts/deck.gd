extends Node2D

var player_deck = ["Pachorro", "Wargato", "Ranbara", "Roruja"]
var card_data_ref

func _ready() -> void:
	player_deck.shuffle() #
	$Control/RichTextLabel.text = str(player_deck.size())
	card_data_ref = preload("res://Scripts/CardDataBase.gd")

func draw_deck():
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)


	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$Control/RichTextLabel.visible = false



	var new_card = preload("res://Scenes/card.tscn").instantiate()
	new_card.global_position = global_position
	var card_image_path = "res://Assets/Cards/" + card_drawn_name + ".webp"
	new_card.get_node("Control/Attack").text = str(card_data_ref.CARD_DATA[card_drawn_name][0])
	new_card.get_node("Control/Health").text = str(card_data_ref.CARD_DATA[card_drawn_name][1])
	new_card.get_node("Control/ManaCost").text = str(card_data_ref.CARD_DATA[card_drawn_name][2])
	new_card.get_node("CardImage").texture = load(card_image_path)

	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	new_card.get_node("AnimationPlayer").play("card_flip")
	$"../PlayerHand".add_card_to_hand(new_card)
	$Control/RichTextLabel.text = str(player_deck.size())

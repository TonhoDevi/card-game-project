extends Node2D

@onready var rich_text_label: RichTextLabel = $Control/RichTextLabel
@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var turn_manager_ref: Node = $"../TurnManager"
@onready var player_hand_ref: Node2D = $"../PlayerHand"
@onready var card_manager_ref: Node2D = $"../PlayerCardManager"
@onready var player_mana_ref: Node2D = $"../PlayerMana"
@onready var visual_manager_ref: Node2D = $"../VisualManager"



var player_deck : Array = ["Pachorro", "Wargato", "Ranbara", "Espirito_Protetor", "Orbe_Pirotecnica", "Estandarte_De_Cura", "Ranbara", "Wargato"]
var card_data_ref
var have_drawed_card: bool = false
var STARTER_DECK_SIZE: int = 0

func _ready() -> void:
	player_deck.shuffle() #
	rich_text_label.text = str(player_deck.size()+1)
	card_data_ref = preload("res://Scripts/universal_card_data_base.gd")
	for i in range(STARTER_DECK_SIZE):
		draw_deck(true)
		have_drawed_card = false
	have_drawed_card = true 

func draw_deck(no_mana : bool):
	# Prevent drawing multiple cards at once
	#if have_drawed_card:
		#return
	#have_drawed_card = true
	# Draw the top card from the deck
	var card_drawn_name: String = player_deck[0]
	if no_mana:
		create_card(card_drawn_name)
	elif player_hand_ref.player_hand.size() <= 4:
		if player_mana_ref.use_mana(1):
			create_card(card_drawn_name)
		else:
			return
	else:
		return
	player_deck.erase(card_drawn_name)
	# Check if deck is empty
	if player_deck.size() == 0:
		collision_shape_2d.disabled = true
		sprite_2d.visible = false
		rich_text_label.visible = false
	# Create new card instance
	

func add_card(new_card: Node2D) -> Node2D :
	card_manager_ref.add_child(new_card)
	new_card.name = "PlayerCard"
	new_card.get_node("AnimationPlayer").play("card_flip")
	player_hand_ref.add_card_to_hand(new_card)
	rich_text_label.text = str(player_deck.size())
	return new_card
	
func create_card(card_drawn_name : String)->void:
	var new_card : Node = preload("res://Scenes/player_card.tscn").instantiate()
	new_card.global_position = global_position
	var card_ref = add_card(new_card)
	var card_image_path : String = "res://Assets/Cards/" + card_drawn_name + ".webp"
	
	card_ref.set_power(card_data_ref.CARD_DATA[card_drawn_name][0], card_data_ref.CARD_DATA[card_drawn_name][1], card_data_ref.CARD_DATA[card_drawn_name][2])
	card_ref.card_type = card_data_ref.CARD_DATA[card_drawn_name][3]
	card_ref.set_ability(card_data_ref.CARD_DATA[card_drawn_name][4])
	card_ref.get_node("Body/CardImage").texture = load(card_image_path)

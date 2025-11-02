extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rich_text_label: RichTextLabel = $Control/RichTextLabel
@onready var card_manager_ref: Node2D = $"../OpponentCardManager"
@onready var opponent_hand_ref: Node2D = $"../OpponentHand"
@onready var opponent_mana_ref: Node2D = $"../OpponentMana"


var opponent_deck : Array = ["Pachorro", "Wargato", "Ranbara", "Espirito_Protetor", "Orbe_Pirotecnica", "Estandarte_De_Cura", "Ranbara", "Wargato"]
var card_data_ref
var STARTER_DECK_SIZE: int = 0

func _ready() -> void:
	opponent_deck.shuffle() #
	rich_text_label.text = str(opponent_deck.size())
	card_data_ref = preload("res://Scripts/universal_card_data_base.gd")
	for i in range(STARTER_DECK_SIZE):
		draw_deck(true)

func draw_deck(no_mana : bool):

	var card_drawn_name: String = opponent_deck[0]
	if !card_drawn_name:
		return
	if no_mana:
		opponent_deck.erase(card_drawn_name)
		create_card(card_drawn_name)
	elif opponent_hand_ref.opponent_hand.size() <=4:
		if opponent_mana_ref.use_mana(1):
			opponent_deck.erase(card_drawn_name)
			create_card(card_drawn_name)
	if opponent_deck.size() == 0:
		sprite_2d.visible = false
		rich_text_label.visible = false
	

func add_card(new_card: Node2D) -> Node2D :
	card_manager_ref.add_child(new_card)
	new_card.name = "OpponentCard"
	opponent_hand_ref.add_card_to_hand(new_card)
	rich_text_label.text = str(opponent_deck.size())
	return new_card
	
func create_card(card_drawn_name : String):
	var new_card : Node = preload("res://Scenes/opponent_card.tscn").instantiate()
	new_card.global_position = global_position
	var card_ref = add_card(new_card)
	var card_image_path : String = "res://Assets/Cards/" + card_drawn_name + ".webp"
	
	card_ref.set_power(card_data_ref.CARD_DATA[card_drawn_name][0], card_data_ref.CARD_DATA[card_drawn_name][1], card_data_ref.CARD_DATA[card_drawn_name][2])
	new_card.card_type = card_data_ref.CARD_DATA[card_drawn_name][3]
	new_card.get_node("Body/CardImage").texture = load(card_image_path)
	

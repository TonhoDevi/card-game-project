extends Node2D

@onready var player_mana_ref: Node2D = $"../PlayerMana"
@onready var player_hand_ref : Node2D = $"../PlayerHand"
@onready var player_card_deck_ref : Node2D = $"../PlayerCardDeck"
@onready var player_table_ref : Node2D = $"../PlayerTable"

@onready var opponent_ia_ref: Node2D = $"../OpponentIA"
@onready var opponent_table_ref: Node2D = $"../OpponentTable"

@onready var visual_manager_ref: Node2D = $"../VisualManager"
@onready var battle_manager_ref: Node = $"../BattleManager"
@onready var input_manager_ref: Node2D = $"../InputManager"
@onready var turn_manager_ref: Node = $"../TurnManager"

@onready var timer: Timer = $Timer

const COLLISION_MAKS_CARD : int = 1
const COLLISION_MAKS_CARD_SLOT : int = 2

var screen_size : Vector2
var card_being_dragged : Node2D
var card_being_select : Node2D

var have_attack_card_this_turn : bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void: 
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,screen_size.x),clamp(mouse_pos.y,0,screen_size.y))

# ======== Dragging HELPERS ======== #	

func start_drag(card : Node2D):
	card_being_dragged = card
	# Detectar se a carta ja estava em um slot
	if !card_being_dragged.card_slot_ref:
		var result = input_manager_ref.ray_cast_at_cursor()
		var card_slot = input_manager_ref.find_card_slot(result)
		if card_slot:
			card_slot.card_in_slot = false
		card_being_dragged.card_slot_ref = null
	
# Stop dragging the card 
func stop_drag():
	if card_being_dragged:
		var result = input_manager_ref.ray_cast_at_cursor()
		var card_slot_found = input_manager_ref.find_card_slot(result)
		if card_slot_found and not card_slot_found.card_in_slot and turn_manager_ref.user_turn == "Player preparation turn":
			if card_being_dragged.card_type == card_slot_found.card_slot_type:
				if player_mana_ref.use_mana(card_being_dragged.get_mana()):
					add_card_to_table(card_being_dragged, card_slot_found)
					return		
		player_hand_ref.add_card_to_hand(card_being_dragged)
		card_being_dragged.card_slot_ref = null
		card_being_dragged.z_index = 0
		card_being_dragged = null
		player_hand_ref.update_hand_positions()


#=======Chose card to attack =======

func chose_card(card : Node2D) -> void:
	if !have_attack_card_this_turn:
		if card_being_select == null:
			card_being_select = card
		elif card_being_select == card:
			card_being_select = null

func opponent_target(card : Node2D) -> void:
	if card_being_select != null:
		have_attack_card_this_turn = true
		perform_attack(card_being_select,card)
		input_manager_ref.can_click = false
		card_being_select = null
		timer.start(0.8)
		await  timer.timeout
		input_manager_ref.can_click = true

func perform_attack(player_card : Node2D, opponent_card : Node2D) -> void:
	if !player_mana_ref.use_mana(1):
		return
	await visual_manager_ref.animate_card_attack(player_card, opponent_card)
	battle_manager_ref.attack(player_card, opponent_card)
	visual_manager_ref.animate_card_retrive(player_card,opponent_card)

# ======== Card Placement ======== #
func add_card_to_table(card: Node2D, card_slot_found: Node2D):
	player_hand_ref.remove_card_from_hand(card)
	player_table_ref.add_card_to_table(card, card.card_type)
	card.z_index = -1
	card.card_slot_ref = card_slot_found
	card.position = card_slot_found.position
	visual_manager_ref.minimize_card(card)
	card_slot_found.card_in_slot = true
	card_slot_found.card_in_slot_ref = card
	card_being_dragged = null
	if card.card_type == "Magic":
		card.trigger_ability(card, opponent_table_ref, 0, self, opponent_ia_ref)

#======== TURN MANAGEMENT ========#

func end_turn():
	have_attack_card_this_turn = false
	player_card_deck_ref.have_drawed_card = false

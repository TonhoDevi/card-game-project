extends Node2D

@onready var player_hand_ref : Node2D = $"../PlayerHand"
@onready var card_deck_ref : Node2D = $"../PlayerCardDeck"
@onready var player_table_ref : Node2D = $"../PlayerTable"
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

var have_place_monster_card_this_turn : bool = false
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


func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parametres = PhysicsPointQueryParameters2D.new()
	parametres.position = get_global_mouse_position()
	parametres.collide_with_areas = true
	parametres.collision_mask = COLLISION_MAKS_CARD_SLOT
	var result = space_state.intersect_point(parametres)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null

func get_card_with_highest_z_index(cards : Array) -> Node2D:
	var highest_z_card : Node2D = cards[0].collider.get_parent()
	var highest_z_index : int = highest_z_card.z_index
	for card in cards:
		var current_card : Node2D = card.collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func start_drag(card : Node2D):
	card_being_dragged = card
	# Detectar se a carta ja estava em um slot
	if !card_being_dragged.card_slot_card_is_in:
		var result = input_manager_ref.ray_cast_at_cursor()
		var card_slot = input_manager_ref.find_card_slot(result)
		if card_slot:
			card_slot.card_in_slot = false
		card_being_dragged.card_slot_card_is_in = null
	
# Stop dragging the card 
func stop_drag():
	if card_being_dragged:
		var result = input_manager_ref.ray_cast_at_cursor()
		var card_slot_found = input_manager_ref.find_card_slot(result)
		if card_slot_found and not card_slot_found.card_in_slot and turn_manager_ref.user_turn == "Player preparation turn" and !have_place_monster_card_this_turn:
			if card_being_dragged.card_type == card_slot_found.card_slot_type:
				if !have_place_monster_card_this_turn:
					have_place_monster_card_this_turn = true
					add_card_to_table(card_being_dragged, card_slot_found)
					return		
		player_hand_ref.add_card_to_hand(card_being_dragged)
		card_being_dragged.card_slot_card_is_in = null
		card_being_dragged.z_index = 0
		card_being_dragged = null
		player_hand_ref.update_hand_positions()


#=======Chose card to attack =======

func chose_card(card : Node2D) -> void:
	if !have_attack_card_this_turn:
		if card_being_select == null:
			if card_being_select == card:
				card_being_select = null
			else:
				card_being_select = card

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
	visual_manager_ref.animate_card_attack(player_card, opponent_card.position)
	battle_manager_ref.attack(player_card, opponent_card, "add")
	

# ======== Card Placement ======== #
func add_card_to_table(card: Node2D, card_slot_found: Node2D):
	player_hand_ref.remove_card_from_hand(card)
	player_table_ref.add_card_to_table(card, card.card_type)
	card.z_index = -1
	card.card_slot_card_is_in = card_slot_found
	card.position = card_slot_found.position
	visual_manager_ref.minimize_card(card)
	card_slot_found.card_in_slot = true
	card_slot_found.card_in_slot_ref = card
	card_being_dragged = null

#======== TURN MANAGEMENT ========#

func end_turn():
	have_place_monster_card_this_turn = false
	have_attack_card_this_turn = false
	card_deck_ref.have_drawed_card = false

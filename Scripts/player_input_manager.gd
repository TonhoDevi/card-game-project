extends Node2D

@onready var card_manager_ref : Node2D = $"../PlayerCardManager"
@onready var deck_ref : Node2D = $"../PlayerCardDeck"
@onready var battle_manager_ref: Node = $"../BattleManager"

const COLLISION_MASK_CARD_HAND : int = 1
const COLLISION_MASK_CARD_IN_SLOT: int = 2
const COLLISION_MASK_CARD_SLOT : int = 4
const COLLISION_MASK_CARD_DECK : int = 8
const COLLISION_MASK_CARD_OPPONENT :int = 16
const COLLISION_MASK_CARD_OPPONENT_HAND : int = 32
const COLLISION_MASK_CARD_OPPONENT_IN_SLOT : int = 64


var game_phase : String = "preparation_phase"
var can_click : bool = true

func change_game_phase(new_phase: String) -> void:
	game_phase = new_phase
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and can_click:
		if event.is_pressed():
			execute_action()
		else:
			card_manager_ref.stop_drag()
			
func execute_action() -> void:
	var result = ray_cast_at_cursor()
	if game_phase == "preparation_phase":
		action_preparation_turn(result)
	if game_phase == "combat_phase":
		action_combat_turn(result)

func ray_cast_at_cursor():
	var space_state  = get_world_2d().direct_space_state
	var parametres = PhysicsPointQueryParameters2D.new()
	parametres.position = get_global_mouse_position()
	parametres.collide_with_areas = true
	var result = space_state.intersect_point(parametres)
	if result.size() > 0:
		return result
	else:
		return null
		
func action_preparation_turn(result):
	var card_found = find_card_in_hand(result)
	if card_found :
		card_manager_ref.start_drag(card_found)
		return
	var deck_found = find_deck(result)
	if deck_found:
		deck_ref.draw_deck()
		return

func action_combat_turn(result):
	var card_found = find_card_in_slot(result)
	if card_found:
		card_manager_ref.chose_card(card_found)
		return
	var opponent_found = find_opponent_in_slot(result)
	if opponent_found:
		card_manager_ref.opponent_target(opponent_found)
	
func find_card_in_hand(result) -> Node2D:
	if result != null:
		for obj in result:
			var result_collision_mask = obj.collider.collision_mask
			if result_collision_mask == COLLISION_MASK_CARD_HAND:
				var deck_found = obj.collider.get_parent()
				return deck_found
	return null
	
func find_card_in_slot(result) -> Node2D:
	if result != null:
		for obj in result:
			var result_collision_mask = obj.collider.collision_mask
			if result_collision_mask == COLLISION_MASK_CARD_IN_SLOT:
				var deck_found = obj.collider.get_parent()
				return deck_found
	return null

func find_card_slot(result) -> Node2D:
	if result != null:
		for obj in result:
			var result_collision_mask = obj.collider.collision_mask
			if result_collision_mask == COLLISION_MASK_CARD_SLOT:
				var deck_found = obj.collider.get_parent()
				return deck_found
	return null

func find_deck(result) -> Node2D:
	if result != null:
		for obj in result:
			var result_collision_mask = obj.collider.collision_mask
			if result_collision_mask == COLLISION_MASK_CARD_DECK:
				var deck_found = obj.collider.get_parent()
				return deck_found
	return null
	
func find_opponent_in_hand(result) -> Node2D:
	if result != null:
		for obj in result:
			var result_collision_mask = obj.collider.collision_mask
			if result_collision_mask == COLLISION_MASK_CARD_OPPONENT_HAND:
				var opponent_found = obj.collider.get_parent()
				return opponent_found
	return null
	
func find_opponent_in_slot(result) -> Node2D:
	if result != null:
		for obj in result:
			var result_collision_mask = obj.collider.collision_mask
			if result_collision_mask == COLLISION_MASK_CARD_OPPONENT_IN_SLOT:
				var opponent_found = obj.collider.get_parent()
				return opponent_found
	return null
		


	

			

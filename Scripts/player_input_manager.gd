extends Node2D

@onready var card_manager_ref : Node2D = $"../PlayerCardManager"
@onready var deck_ref : Node2D = $"../PlayerCardDeck"
const COLLISION_MASK_CARD : int = 1
const COLLISION_MASK_CARD_DECK : int = 4
const COLLISION_MASK_CARD_ENEMY :int = 6
var game_phase : String = "preparation_phase"
var can_click : bool = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and can_click:
		if event.is_pressed():
			ray_cast_at_cursor()
		else:
			card_manager_ref.stop_drag()
			
			
func change_game_phase(new_phase: String) -> void:
	game_phase = new_phase
	
func find_card(result) -> Node2D:
	var result_collision_mask = result[0].collider.collision_mask
	if result_collision_mask == COLLISION_MASK_CARD:
		var card_found = result[0].collider.get_parent()
		return card_found
	else:
		return null
	
func find_deck(result) -> Node2D:
	var result_collision_mask = result[0].collider.collision_mask
	if result_collision_mask == COLLISION_MASK_CARD_DECK:
		var deck_found = result[0].collider.get_parent()
		return deck_found
	else:
		return null
	
func find_enemy(result) -> Node2D:
	var result_collision_mask = result[0].collider.collision_mask
	if result_collision_mask == COLLISION_MASK_CARD_ENEMY:
		var enemy_found = result[0].collider.get_parent()
		return enemy_found
	else:
		return null
		
func action_preparation_turn(result):
	var card_found = find_card(result)
	if card_found :
		card_manager_ref.start_drag(card_found)
		return
	var deck_found = find_deck(result)
	if deck_found:
		deck_ref.draw_deck()
		return

func action_combat_turn(result):
	print(result.name)
	var card_found = find_card(result)
	print("carta achada foi " + card_found.name)
	if card_found:
		card_manager_ref.chose_card(card_found)
		print(card_found)
		return
	var enemy_found = find_enemy(result)
	if enemy_found:
		print(enemy_found)
		card_manager_ref.enemy_target(enemy_found)
	

func ray_cast_at_cursor():
	var space_state  = get_world_2d().direct_space_state
	var parametres = PhysicsPointQueryParameters2D.new()
	parametres.position = get_global_mouse_position()
	parametres.collide_with_areas = true
	var result = space_state.intersect_point(parametres)
	if result.size() > 0:
		if game_phase == "preparation_phase":
			action_preparation_turn(result)
		if game_phase == "combat_phase":
			action_combat_turn(result)
			

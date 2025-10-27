extends Node2D

@onready var card_manager_ref : Node2D = $"../PlayerCardManager"
@onready var deck_ref : Node2D = $"../PlayerCardDeck"
const COLLISION_MASK_CARD : int = 1
const COLLISION_MASK_CARD_DECK : int = 4
var game_phase : String = "PreparationTurn"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			ray_cast_at_cursor()
		else:
			card_manager_ref.stop_drag()
func change_game_phase(new_phase: String) -> void:
	game_phase = new_phase

func ray_cast_at_cursor():
	var space_state  = get_world_2d().direct_space_state
	var parametres = PhysicsPointQueryParameters2D.new()
	parametres.position = get_global_mouse_position()
	parametres.collide_with_areas = true
	var result = space_state.intersect_point(parametres)

	if result.size() > 0:

		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK_CARD:

			var card_found = result[0].collider.get_parent()
			if card_found and game_phase == "PreparationTurn":
				card_manager_ref.start_drag(card_found)
			elif card_found and game_phase == "CombatTurn":
				return

		elif result_collision_mask == COLLISION_MASK_CARD_DECK:

			var card_deck = result[0].collider.get_parent()
			if card_deck and game_phase == "PreparationTurn":
				deck_ref.draw_deck()

extends Node2D

const COLLISION_MASK_CARD : int = 1
const COLLISION_MASK_CARD_DECK : int = 4
var card_manager_ref : Node
var deck_ref : Node

func _ready() -> void:
	card_manager_ref = get_node("../CardManager")
	deck_ref = get_node("../CardDeck")



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			ray_cast_at_cursor()
		else:
			card_manager_ref.stop_drag()

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
			if card_found:
				card_manager_ref.start_drag(card_found)

		elif result_collision_mask == COLLISION_MASK_CARD_DECK:
			var card_deck = result[0].collider.get_parent()
			if card_deck:
				deck_ref.draw_deck()

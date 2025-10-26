extends Node2D


const COLLISION_MAKS_CARD = 1
const COLLISION_MAKS_CARD_SLOT = 2
const DEFAULT_SCALE_NODE = Vector2(0.85, 0.85)
const SMALL_SCALE_NODE = Vector2(0.7, 0.7)
var screen_size
var card_being_dragged
var is_hovering_card
var player_hand_ref
var card_manager_ref


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_ref = get_node("../PlayerHand")
	card_manager_ref = get_node("../CardManager")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void: 
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,screen_size.x),clamp(mouse_pos.y,0,screen_size.y))

# ======== Dragging HELPERS ======== #	
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parametres = PhysicsPointQueryParameters2D.new()
	parametres.position = get_global_mouse_position()
	parametres.collide_with_areas = true
	parametres.collision_mask = COLLISION_MAKS_CARD
	var result = space_state.intersect_point(parametres)
	if result.size() > 0:
		card_being_dragged = get_card_with_highest_z_index(result)

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

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	for card in cards:
		var current_card = card.collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card


func start_drag(card):
	card.scale = DEFAULT_SCALE_NODE
	card_being_dragged = card
	# Detectar se a carta ja estava em um slot
	if card_being_dragged.get_node("Area2D").monitoring == false:
		var card_slot = raycast_check_for_card_slot()
		if card_slot:
			card_slot.card_in_slot = false
		card_being_dragged.get_node("Area2D").set_deferred("monitoring",true)
	


# 
func stop_drag():
	if card_being_dragged:
		card_being_dragged.scale = DEFAULT_SCALE_NODE
		var card_slot_found = raycast_check_for_card_slot()
		if card_slot_found and not card_slot_found.card_in_slot:
			player_hand_ref.remove_card_from_hand(card_being_dragged)
			card_being_dragged.scale = SMALL_SCALE_NODE
			card_being_dragged.position = card_slot_found.position
			card_being_dragged.get_node("Area2D").set_deferred("monitoring",false)
			card_slot_found.card_in_slot = true
		else:
			player_hand_ref.add_card_to_hand(card_being_dragged)
		card_being_dragged = null
#======== CARD SLOT RAYCASTING AND HELPERS ========#

# Connect card signals
func connect_card_signals(card):
	card.connect("mouse_entered_card",_on_card_mouse_entered)
	card.connect("mouse_exited_card",_on_card_mouse_exited)

# Helper functions for card hovering
func _on_card_mouse_entered(card):
	if !is_hovering_card:
		is_hovering_card = true
		highlight_card(card,true)
	
# Helper functions for card hovering
func _on_card_mouse_exited(card):
	if !card_being_dragged:
		highlight_card(card,false)
		var new_card_hover = raycast_check_for_card()
		if new_card_hover:
			highlight_card(new_card_hover,true)
		else:
			is_hovering_card = false

# Helper function to raycast for card slots
func highlight_card(card, hovering: bool):
	if hovering:
		card.scale = Vector2(1.1,1.1)
		card.z_index = 2
		card.modulate = Color(1,1,1,1.2)
	else:
		if card == card_being_dragged:
			card.scale = SMALL_SCALE_NODE
		else:
			card.scale = DEFAULT_SCALE_NODE
		card.z_index = 1
		card.modulate = Color(1,1,1,1)

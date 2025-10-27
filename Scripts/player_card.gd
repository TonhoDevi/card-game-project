extends Node2D


signal mouse_entered_card
signal mouse_exited_card

@onready var visual_manager: Node2D = $"../../CardManager/VisualManager"


var start_position : Vector2
var card_slot_card_is_in : Node
var card_type : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals to the visual_card_interaction script
	visual_manager.connect_card_signals(self)
	


func _on_area_2d_mouse_exited() -> void:
	emit_signal("mouse_exited_card",self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("mouse_entered_card",self)

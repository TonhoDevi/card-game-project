extends Node2D


signal mouse_entered_card
signal mouse_exited_card
var start_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals to the card manager
	get_parent().connect_card_signals(self)
	


func _on_area_2d_mouse_exited() -> void:
	emit_signal("mouse_exited_card",self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("mouse_entered_card",self)

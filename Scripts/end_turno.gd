extends Button

@onready var card_manager: Node2D = $"../../CardManager"
@onready var turn_number_label: RichTextLabel = $"../TurnNumber"
var turn_number: int = 1


func _on_ready() -> void:
	turn_number_label.text = str(turn_number)


func _on_pressed() -> void:
	card_manager.end_turn()
	turn_number += 1
	turn_number_label.text = str(turn_number)

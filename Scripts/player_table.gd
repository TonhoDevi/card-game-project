extends Node2D


@onready var magic_table : Node = $"Magics"
@onready var hero_table : Node = $"Heroes"
var cards_on_hero_table : Array = []
var cards_on_magic_table : Array = []


func add_card_to_table(card: Node2D, table_type: String) -> void:
	if table_type == "Hero":
		cards_on_hero_table.append(card)
	elif table_type == "Magic":
		cards_on_magic_table.append(card)
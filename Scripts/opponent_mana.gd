extends Node2D

@onready var opponent_mana_num: RichTextLabel = $"../Control/OpponentManaNum"
@onready var opponent_mana_pool : int = 5
var DADOS : Dictionary = {
	"D4" : 4,
	"D6" : 6,
	"D8" : 8,
	"D10": 10,
	"D12": 12	
}

func _ready() -> void:
	update_visual()

func add_mana(amount : int) -> void:
	opponent_mana_pool += amount
	update_visual()

func gain_mana(dado : String) -> void:
	var num : int = int(randf_range(1.0, float(DADOS[dado])))
	opponent_mana_pool += num
	update_visual()
	

func use_mana(amount : int) -> bool:
	if opponent_mana_pool >= amount:
		opponent_mana_pool -= amount
		update_visual()
		return true
	else:
		return false
		
func update_visual():
	opponent_mana_num.text = 	"Mana\n" + str(opponent_mana_pool)

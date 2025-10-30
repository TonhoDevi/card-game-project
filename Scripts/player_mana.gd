extends Node2D

@onready var player_mana_num: RichTextLabel = $"../Control/PlayerManaNum"
@onready var player_mana_pool : int = 5
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
	player_mana_pool += amount
	update_visual()

func gain_mana(dado : String) -> void:
	var num : int = int(randf_range(0, DADOS[dado][0]))
	player_mana_pool += num
	

func use_mana(amount : int) -> bool:
	if player_mana_pool >= amount:
		player_mana_pool -= amount
		update_visual()
		return true
	else:
		return false
		
func update_visual():
	player_mana_num.text = 	"Mana\n" + str(player_mana_pool)

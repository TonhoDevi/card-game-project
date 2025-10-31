extends Node2D

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
	if opponent_mana_pool > 10:
		opponent_mana_pool = 10
	update_visual()

func use_mana(amount : int) -> bool:
	if opponent_mana_pool >= amount:
		opponent_mana_pool -= amount
		update_visual()
		return true
	else:
		return false
		
func animation_pop(gem : Node2D ,trigger : bool):
	if trigger:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(gem,"scale", Vector2(1.5,1.5), 0.5)
	else:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(gem,"scale", Vector2(0,0), 0.5)

func update_visual():
	var all_node = get_children()
	for num in range(all_node.size()):
		if num <= (opponent_mana_pool-1):
			animation_pop(all_node[num].get_node("gem"), true)
		else:
			animation_pop(all_node[num].get_node("gem"), false)
		await get_tree().create_timer(0.1).timeout

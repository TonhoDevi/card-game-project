extends Node2D
@onready var player_mana_pool : int = 0
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
	if player_mana_pool > 10:
		player_mana_pool = 10
	update_visual()

func gain_mana(dado : String) -> void:
	var num : int = int(randf_range(1.0, float(DADOS[dado])))
	player_mana_pool += num
	if player_mana_pool > 10:
		player_mana_pool = 10
	update_visual()
	

func use_mana(amount : int) -> bool:
	if player_mana_pool >= amount:
		player_mana_pool -= amount
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
		if num <= (player_mana_pool-1):
			animation_pop(all_node[num].get_node("gem"), true)
		else:
			animation_pop(all_node[num].get_node("gem"), false)
		await get_tree().create_timer(0.1).timeout

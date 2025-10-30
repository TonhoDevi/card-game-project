extends Node2D

@onready var card_gravy_yard: Node2D = $"../../CardGravyYard"
@onready var attack_label: RichTextLabel = $Control/Attack
@onready var health_label: RichTextLabel = $Control/Health
@onready var mana_cost_label: RichTextLabel = $Control/ManaCost
@onready var area_2d: Area2D = $Area2D

var start_position : Vector2
var card_slot_card_is_in : Node
var card_type : String
var vci_ref : Node

var health : float
var attack : float

var temp_health : float
var temp_attack : float

func set_power(att: float, heal : float) -> void:
	health = heal
	temp_health = heal
	attack = att
	temp_attack = att

func get_attack() -> float:
	return temp_attack
func get_health() -> float:
	return temp_health
	
func clean_power_att() -> void:
	temp_attack = attack
	
func clean_power_heal() -> void:
	temp_health = health

func set_attack(add : float, mult : float, type : String) -> void:
	if type == "add":
		temp_attack += add
	elif type == "mult":
		temp_attack *= mult
	update_info()
		
func set_health(add : float, mult : float, type : String) -> void:
	if type == "add":
		temp_health += add
	elif type == "mult":
		temp_health *= mult
	update_info()
	if temp_health < 0:
		dead_of_card()
	
func update_info() -> void:
	attack_label.text = str(int(temp_attack))
	health_label.text = str(int(temp_health))

func dead_of_card():
	card_gravy_yard.add_card_to_gravy_yard(self)

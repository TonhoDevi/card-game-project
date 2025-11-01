extends Node2D

@onready var card_gravy_yard: Node2D = $"../../OpponentCardGravyYard"
@onready var attack_label: RichTextLabel = $Control/Attack
@onready var health_label: RichTextLabel = $Control/Health
@onready var mana_cost_label: RichTextLabel = $Control/ManaCost
@onready var area_2d: Area2D = $Area2D

var start_position : Vector2
var card_slot_card_is_in : Node
var card_type : String
var vci_ref : Node

var health : int
var attack : int
var mana : int

var temp_health : int
var temp_attack : int
var temp_mana : int

func set_power(att: int, heal : int, mn : int) -> void:
	health = heal
	temp_health = heal
	attack = att
	temp_attack = att
	mana = mn
	temp_mana = mn
	update_info()

func get_attack() -> int:
	return temp_attack
func get_health() -> int:
	return temp_health
func get_mana() -> int:
	return temp_mana

func clean_power_att() -> void:
	temp_attack = attack
	
func clean_power_heal() -> void:
	temp_health = health

func clean_power_mana() -> void:
	temp_mana = mana

func set_attack(add : int, mult : int, type : String) -> void:
	if type == "add":
		temp_attack += add
	elif type == "mult":
		temp_attack *= mult
	update_info()
		
func set_health(add : int, mult : int, type : String) -> void:
	if type == "add":
		temp_health += add
	elif type == "mult":
		temp_health *= mult
	update_info()
	if temp_health <= 0:
		dead_of_card()
	
func update_info() -> void:
	attack_label.text = str(temp_attack)
	health_label.text = str(temp_health)
	mana_cost_label.text = str(temp_mana)

func dead_of_card():
	card_gravy_yard.add_card_to_gravy_yard(self)

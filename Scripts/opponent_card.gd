extends Node2D

@onready var card_gravy_yard: Node2D = $"../../OpponentCardGravyYard"
@onready var opponent_table: Node2D = $"../../OpponentTable"
@onready var mana_cost_label: RichTextLabel = $Body/Control/ManaCost

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_label: RichTextLabel = $Body/Control/Attack
@onready var health_label: RichTextLabel = $Body/Control/Health
@onready var area_2d: Area2D = $Area2D

const card_user = "Opponent"

var start_position : Vector2
var card_slot_ref : Node
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

func set_attack(damage : int) -> void:
	temp_attack += damage
	update_info()
		
func take_damage(damage : int) -> void:
	temp_health += damage
	if temp_health <= 0:
		temp_health = 0
		dead_of_card()
	animation_player.play("take_damage")
	update_info()
	
func dead_of_card() -> void:
	await animation_player.animation_finished
	card_slot_ref.card_in_slot_ref = null
	card_slot_ref.card_in_slot = false
	if card_type == "Hero":
		opponent_table.cards_on_hero_table.erase(self)
	else:
		opponent_table.cards_on_magic_table.erase(self)
	card_gravy_yard.add_card_to_gravy_yard(self)
	
func update_info() -> void:
	attack_label.text = str(temp_attack)
	if temp_attack < attack:
		attack_label.modulate = Color.RED
	elif temp_attack == attack :
		attack_label.modulate = Color.WHITE
	else:
		attack_label.modulate = Color.LAWN_GREEN
		
	health_label.text = str(temp_health)
	if temp_health < health:
		health_label.modulate = Color.RED
	elif temp_health == health :
		health_label.modulate = Color.WHITE
	else:
		health_label.modulate = Color.LAWN_GREEN
		
	mana_cost_label.text = str(temp_mana)
	if temp_mana < mana:
		mana_cost_label.modulate = Color.RED
	elif temp_mana == mana :
		mana_cost_label.modulate = Color.WHITE
	else:
		mana_cost_label.modulate = Color.LAWN_GREEN

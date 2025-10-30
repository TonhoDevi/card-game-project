extends Node2D


signal mouse_entered_card
signal mouse_exited_card

@onready var select_to_attack: CPUParticles2D = $select_to_attack
@onready var card_gravy_yard: Node2D = $"../../PlayerCardGravyYard"
@onready var visual_manager: Node2D = $"../../VisualManager"
@onready var attack_label: RichTextLabel = $Control/Attack
@onready var health_label: RichTextLabel = $Control/Health
@onready var mana_cost_label: RichTextLabel = $Control/ManaCost

var start_position : Vector2
var card_slot_card_is_in : Node
var card_type : String

var health : float
var attack : float
var mana : int

var temp_health : float
var temp_attack : float
var temp_mana : int

func set_power(att: float, heal : float, mn : int) -> void:
	health = heal
	temp_health = heal
	attack = att
	temp_attack = att
	mana = mn
	temp_mana = mn
	update_info()

func get_attack() -> float:
	return temp_attack
func get_health() -> float:
	return temp_health
func get_mana() -> int :
	return temp_mana
	
func clean_power_att() -> void:
	temp_attack = attack
	
func clean_power_heal() -> void:
	temp_health = health
func clean_power_mana() -> void:
	temp_mana = mana

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
	if temp_health <= 0:
		dead_of_card()
	
func update_info() -> void:
	attack_label.text = str(int(temp_attack))
	health_label.text = str(int(temp_health))
	mana_cost_label.text = str(int(temp_mana))
	
func dead_of_card():
	card_gravy_yard.add_card_to_gravy_yard(self)
	
func _ready() -> void:
	visual_manager.connect_card_signals(self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("mouse_exited_card",self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("mouse_entered_card",self)

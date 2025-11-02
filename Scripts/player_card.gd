extends Node2D


signal mouse_entered_card
signal mouse_exited_card

@onready var card_gravy_yard: Node2D = $"../../PlayerCardGravyYard"
@onready var visual_manager: Node2D = $"../../VisualManager"
@onready var  player_table: Node2D = $"../../PlayerTable"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var mana_cost_label: RichTextLabel = $Body/Control/ManaCost
@onready var select_to_attack: CPUParticles2D = $select_to_attack
@onready var attack_label: RichTextLabel = $Body/Control/Attack
@onready var health_label: RichTextLabel = $Body/Control/Health

const card_user = "Player"
var start_position : Vector2
var card_slot_ref : Node
var card_type : String
var ability_script_ref

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
func get_mana() -> int :
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
		
func take_damage(damage) -> void:
	temp_health += damage
	animation_player.play("take_damage")
	if temp_health <= 0:
		temp_health = 0
		dead_of_card()
	update_info()
		
func heal_effect(num: int)-> void:
	temp_health += num
	if temp_health > health:
		temp_health = health
	update_info()
	
func set_ability(path: String) -> void:
	ability_script_ref = load(path).new()
	
	
func trigger_ability(card : Node2D, target_table : Node2D, slot : int , player_manager : Node2D, opponent_ia : Node2D):
	ability_script_ref.trigger(card, player_manager, opponent_ia)
	
	
func dead_of_card() -> void:
	await animation_player.animation_finished
	card_slot_ref.card_in_slot_ref = null
	card_slot_ref.card_in_slot = false
	if card_type == "Hero":
		player_table.cards_on_hero_table.erase(self)
	else:
		player_table.cards_on_magic_table.erase(self)
	card_gravy_yard.add_card_to_gravy_yard(self)
	
func _ready() -> void:
	visual_manager.connect_card_signals(self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("mouse_exited_card",self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("mouse_entered_card",self)
	
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

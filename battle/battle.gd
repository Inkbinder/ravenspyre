extends Node2D

@onready var card_holder = $CardHolder
@onready var enemy_holder = $EnemyHolder

@onready var party_spawns = [ $PartyMember1, $PartyMember2, $PartyMember3 ]

var bingo_scene = preload("res://bingo_card/bingo_card.tscn");
var enemy = preload("res://enemy/enemy.tscn")
var party_member = preload("res://party_member/party_member.tscn")

var party_members = [{'name': 'Alicia', 'class': 'cleric', 'max_health': 10}, {'name': 'Belle', 'class': 'guard', 'max_health': 10}, {'name': 'Christine', 'class': 'mage', 'max_health': 10}]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0,3):
		var party_member = party_member.instantiate()
		party_member.set_current_class(party_members[i].class)
		party_spawns[i].add_child(party_member)
		var bingo_card = bingo_scene.instantiate()
		bingo_card.set_character_name(party_members[i].name)
		card_holder.add_child(bingo_card)
		bingo_card.position = Vector2(0, i * 416)
		bingo_card.party_member = party_member
		bingo_card.party_member_data = party_members[i]
	var enemy = enemy.instantiate()
	enemy_holder.add_child(enemy)
	setup_card_number_link()
	
func setup_card_number_link():
	for card in get_tree().get_nodes_in_group('bingo_cards'):
		for num in get_tree().get_nodes_in_group('popup_numbers'):
			num.number_visible.connect(card.handle_visible_number)
			num.number_faded.connect(card.handle_faded_number)
			card.correct_tap.connect(num.complete)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

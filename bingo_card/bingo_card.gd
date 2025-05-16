extends Node2D

@onready var character_name_text = $Control/CharacterName
@onready var bingo_grid = $BingoGrid
@onready var selected_area: CollisionObject2D = $SelectedArea

signal correct_tap(num)

var bingo_number = preload("res://bingo_card/card_number/card_number.tscn")
var character_name = ''

var selected = false

var active_numbers = []

# A dictionary, keyed by number, of active numbers on the card
var number_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	selected_area.mouse_entered.connect(func(): self.selected = true)
	selected_area.mouse_exited.connect(func(): self.selected = false)
	add_to_group('bingo_cards')
	character_name_text.text = character_name
	create_grid()
	pass # Replace with function body.

func set_character_name(new_name):
	character_name = new_name
	if (character_name_text):
		character_name_text.text = new_name

func _unhandled_input(event):
	if event.is_action_pressed('select') and selected:
		print('tapped')
		var matched = false;
		for i in active_numbers:
			if number_dict.has(i):
				print('found')
				matched = true
				handle_correct_tap(i)
				
		if !matched:
			print('Todo: ouch')
			#TODO: Work out what to do here, losing health seems punitive?
			

func handle_correct_tap(num_tapped):
	correct_tap.emit(num_tapped)
	number_dict.get(num_tapped).set_active(false)
	number_dict.erase(num_tapped)
	#TODO: Determine source
	#TODO: If source is party_member trigger 'attack' - play attack animation and then reduce health of random enemy (make targeting part of game logic??)
	#TODO: If source is enemy trigger 'block' - play block animation on all party members then return to idle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handle_visible_number(num):
	active_numbers.append(num)

func handle_faded_number(num):
	active_numbers.remove_at(active_numbers.find(num))
	if number_dict.has(num):
		handle_damage()

func handle_damage():
	print('ouch')
	#TODO: Check if number was in number_dict and if so trigger getting hit	
	pass

func create_grid():
	# First, generate numbers for each column with no duplicates
	var columns = []
	var used_numbers = []
	
	for x in range(10):
		var column_numbers = []
		for y in range(3):
			var new_number = 0
			var attempts = 0
			
			# Try to find a unique number that hasn't been used yet
			while attempts < 50:  # Limit attempts to prevent infinite loops
				new_number = x * 10 + randi_range(0, 9)
				if new_number > 0 and not new_number in used_numbers:
					break
				attempts += 1
			
			# Add the unique number to our lists
			column_numbers.append(new_number)
			used_numbers.append(new_number)
		
		# Sort each column in ascending order
		column_numbers.sort()
		columns.append(column_numbers)
	
	# Create and position the sorted card numbers
	var card_nodes = []
	for x in range(10):
		var column_nodes = []
		for y in range(3):
			var new_number = bingo_number.instantiate()
			new_number.set_card_number(columns[x][y])
			new_number.add_to_group("card_numbers")
			bingo_grid.add_child(new_number)
			new_number.position = Vector2(x * 96, y * 96)
			column_nodes.append(new_number)
		card_nodes.append(column_nodes)
	
	# Set 15 numbers as active, ensuring at least one per column
	var remaining_to_activate = 15
	
	# First, activate one number in each column
	for x in range(10):
		var random_row = randi() % 3
		var selected_node = card_nodes[x][random_row]
		selected_node.set_active(true)
		number_dict[selected_node.get_card_number()] = selected_node
		remaining_to_activate -= 1
	
	# Then randomly distribute the remaining activations
	var available_positions = []
	for x in range(10):
		for y in range(3):
			# Skip positions already activated
			if card_nodes[x][y].is_active == false:
				available_positions.append(Vector2(x, y))
	
	# Shuffle the available positions
	available_positions.shuffle()
	
	# Activate the remaining numbers
	for i in range(remaining_to_activate):
		if i < available_positions.size():
			var pos = available_positions[i]
			var selected_node = card_nodes[int(pos.x)][int(pos.y)]
			selected_node.set_active(true)
			number_dict[selected_node.get_card_number()] = selected_node

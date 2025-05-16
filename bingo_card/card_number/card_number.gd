extends Node2D


@onready var number_display = $PatternGridPaper/Control/Number
var card_number = 0;
var is_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	number_display.text = '[center][color="black"]' + str(card_number) + '[/color][/center]'
	number_display.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_card_number(card_no):
	card_number = card_no
	if (number_display):
		number_display.text = '[center][color="black"]' + str(card_no) + '[/color][/center]'
		
func get_card_number():
	return card_number
		
func set_active(active):
	is_active = active
	if (number_display):
		number_display.visible = is_active
	

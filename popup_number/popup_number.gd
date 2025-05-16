extends Node2D

signal number_visible(number)
signal number_faded(number)

@onready var number_display = $RoundBrown/Control/Number
var card_number = 0
var min_timeout = 1
var max_timeout = 3
var min_delay = 0.1
var max_delay = 10
var source = ''

var next_spawn_timer: Timer = Timer.new()

var current_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('popup_numbers')
	next_spawn_timer.one_shot = true
	add_child(next_spawn_timer)
	next_spawn_timer.timeout.connect(self.trigger_new_number)
	trigger({'min_timeout': 1, 'max_timeout': 3, 'min_delay': 0.1, 'max_delay': 10, 'source': 'internal'})
	pass


func reset():
	modulate = Color.hex(0x00000000)
	scale = Vector2(0.1, 0.1)
	next_spawn_timer.start(randf_range(min_delay, max_delay))
	
func trigger(data):
	card_number = randi_range(1,99)
	min_timeout = data['min_timeout']
	max_timeout = data['max_timeout']
	min_delay = data['min_delay']
	max_delay = data['max_delay']
	source = data['source']
	next_spawn_timer.start(randf_range(min_delay, max_delay))
	
func trigger_new_number():
	card_number = randi_range(1,99)
	retrigger()
	
func retrigger():
	number_visible.emit(card_number)
	number_display.text = '[center][color="black"]' + str(card_number) + '[/color][/center]'
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate", Color.WHITE, 1)
	current_tween.parallel().tween_property(self, "scale", Vector2(.75,.75), 0.5)
	current_tween.chain().tween_property(self, "modulate", Color.hex(0xff000000), randf_range(min_timeout, max_timeout))
	current_tween.chain().tween_callback(self.fail)

func fail():
	number_faded.emit(card_number)
	reset()

func complete(num):
	if card_number == num:
		print('stop')
		current_tween.stop()
		reset()
	

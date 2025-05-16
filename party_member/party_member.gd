extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

var classes = {
	'cleric': preload("res://party_member/assets/cleric/cleric_sprite_frames.tres"),
	'mage': preload("res://party_member/assets/mage/mage_sprite_frames.tres"),
	'guard': preload("res://party_member/assets/guard/guard_sprite_frames.tres")
}

var current_class = 'cleric'

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.sprite_frames = classes[current_class]
	animated_sprite.animation = 'idle'
	animated_sprite.play('idle')

func set_current_class(new_class):
	current_class = new_class
	if (animated_sprite):
		animated_sprite.sprite_frames = classes[new_class]
		animated_sprite.animation = 'idle'
		animated_sprite.play('idle')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass 

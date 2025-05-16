extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Play default animation automatically when instantiated
	if animated_sprite:
		animated_sprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass 

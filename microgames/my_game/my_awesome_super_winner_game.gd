extends Microgame

@export var frog : CharacterBody2D

@export var banana1 : CharacterBody2D
@export var banana2 : CharacterBody2D
@export var banana3 : CharacterBody2D

func _ready():
	super()
	randomize()
	
	banana1.position.x = randf_range(0, 1200)
	banana2.position.x = randf_range(0, 1200)
	banana3.position.x = randf_range(0, 1200)
	
	
func _process(delta):
	print(frog.scale)
	if frog.dead:
		#print("YOU WIN YAYAYAYAYYAY")
		win_game.emit()

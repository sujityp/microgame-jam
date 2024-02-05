extends Microgame
@export var triangle : PackedScene
@export var diamond : CharacterBody2D

func _ready():
	super()

	for i in range(50):
		var inst = triangle.instantiate() as CharacterBody2D
		inst.diamond = diamond
		add_child(inst)
	
	
func _process(delta):
	if diamond.dead:
		lose_game.emit()


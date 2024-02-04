extends Microgame

@export var explosion : PackedScene

func _ready():
	super()
	$Music.play()
func _process(delta):
	if $BigGuyMainChar.scale.x == 3: 
		win_game.emit()


func create_explosion_at(thing : Node2D):
	var inst = explosion.instantiate() as Sprite2D
	add_child(inst)
	inst.global_position = thing.position


func _on_bomb_timer_exploded():
	if not $BigGuyMainChar.winner:
		create_explosion_at($BigGuyMainChar)
		$BigGuyMainChar.scale = Vector2.ZERO

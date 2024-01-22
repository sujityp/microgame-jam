extends Microgame


var Raft
var Pirate
var Explosion = preload("res://microgames/knight_game/explosion/explosion.tscn")
var SharkPos1
var SharkPos2
var lost = false


func _ready():
	super()
	randomize()
	Pirate = $Pirate
	Raft = $RaftSprite
	SharkPos1 = $RaftSprite/SharkPosition1
	SharkPos2 = $RaftSprite/SharkPosition2
	
	# raft pos x should be from 250 to 800
	# raft pos y should be 580
	var pos_list = [0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4]
	var randint = randi_range(0, len(pos_list)-1)
	print(pos_list[randint])
	
	Raft.position = Vector2(250 + pos_list[randint]*110, 580)
	
	# shark1 position should be (-331, -18) in relation to raft by default, or (500, -18) if raft is at left edge of screen
	# shark2 position should be (230, -48) in relation to raft
	if (pos_list[randint] == 0) or (pos_list[randint] == 1):
		print(1235)
		SharkPos1.position = Vector2(500, 0)
		print(SharkPos1.position)


func _process(_delta):
	if Pirate.position.y >= 700 and not lost:
		lose()
		lost = true


func win():
	var insts = [Explosion.instantiate(), Explosion.instantiate()]
	add_child(insts[0])
	add_child(insts[1])
	insts[0].global_position = SharkPos1.global_position
	insts[1].global_position = SharkPos2.global_position
	SharkPos1.hide()
	SharkPos2.hide()
	win_game.emit()


func lose():
	Pirate.kill()
	lose_game.emit()


func _on_pirate_jumped():
	var Plank_col_shape = $Plank/CollisionShape2D
	Plank_col_shape.disabled = true


func _on_safe_area_body_entered(body):
	if body.is_in_group("player"):
		win()
		Pirate.velocity = Vector2.ZERO
		Pirate.alive = false

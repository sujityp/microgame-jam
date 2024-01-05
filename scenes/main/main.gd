extends Node2D
class_name Main

@export var microgames : Array[PackedScene]

var current_mg : Microgame
var mg_won : bool = false
var score : int = 0

@onready var room_anim = $Room/AnimationPlayer
@onready var timer : Timer = $Timer

func _ready():
	timer.start()


func load_random_microgame():
	var rand_idx = randi() % microgames.size()
	load_microgame(microgames[rand_idx])
	
	
func load_microgame(microgame : PackedScene):
	var inst = microgame.instantiate() as Microgame
	current_mg = inst
	
	inst.finish_game.connect(on_microgame_done)
	inst.win_game.connect(func(): mg_won = true)
	inst.lose_game.connect(func(): pass) # losing doesnt change a win
	
	room_anim.play("zoom_in")
	add_child(inst)
	

func on_microgame_done():
	# if not already won, look at the timeout setting
	var won = mg_won or (not current_mg.lose_on_timeout)
	
	if won:
		score += 1
	else:
		pass
	
	room_anim.play("zoom_out")
	await room_anim.animation_finished
	unload_current_microgame()
	timer.start()


func unload_current_microgame():
	current_mg.queue_free()
	current_mg = null


func _on_timer_timeout():
	load_random_microgame()

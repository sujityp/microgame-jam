extends Node2D
class_name Main

@export var microgames : Array[PackedScene]

var current_mg : Microgame
var mg_won : bool = false
var score : int = 0
var time_scale : float = 1

@onready var room_anim = $Room/AnimationPlayer
@onready var win_sound = $Win
@onready var lose_sound = $Loss
@onready var next_sound = $Next

func _ready():
	load_random_microgame()
	Engine.time_scale = time_scale


func load_random_microgame():
	var rand_idx = randi() % microgames.size()
	load_microgame(microgames[rand_idx])
	
	
func load_microgame(microgame : PackedScene):
	var inst = microgame.instantiate() as Microgame
	current_mg = inst
	
	inst.finish_game.connect(on_microgame_done)
	inst.win_game.connect(func(): mg_won = true)
	inst.lose_game.connect(func(): pass) # losing doesnt change a win
	mg_won = false
	
	room_anim.play("zoom_in")
	add_child(inst)
	

func on_microgame_done():
	# if not already won, look at the timeout setting
	var won = mg_won or (not current_mg.lose_on_timeout)
	
	room_anim.play("zoom_out")
	await room_anim.animation_finished
	unload_current_microgame()
	
	if won:
		score += 1
	else:
		pass
	
	if won:
		win_sound.play()
	else:
		lose_sound.play()
		
	await get_tree().create_timer(1.75).timeout
	next_sound.play()
	await get_tree().create_timer(1).timeout
	load_random_microgame()


func unload_current_microgame():
	current_mg.queue_free()
	current_mg = null

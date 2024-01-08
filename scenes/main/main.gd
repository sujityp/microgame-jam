extends Node2D
class_name Main

@export var microgames : Array[PackedScene]

var current_mg : Microgame
var mg_won : bool = false
var score : int = 0
var time_scale : float = 1

# Room
@onready var room_anim = $AnimationPlayer
@onready var win_sound = $Win
@onready var lose_sound = $Loss
@onready var next_sound = $Next

# UI
@onready var score_anim = $UI/Control/ScoreLabel/AnimationPlayer
@onready var score_label = $UI/Control/ScoreLabel
@onready var lives_label = $UI/Control/LivesLabel
@onready var message_label = $UI/Control/MessageLabel
@onready var control_image = $UI/Control/ControlImage
const control_frames = { # frame number for the sprite
	Microgame.ControlType.MOUSE : 1,
	Microgame.ControlType.KEYBOARD : 0,
	Microgame.ControlType.Both : 2
}

func _ready():
	start_new_microgame()
	Engine.time_scale = time_scale

func start_new_microgame():
	var rand_idx = randi() % microgames.size()
	load_microgame(microgames[rand_idx])
	
	message_label.text = current_mg.message
	control_image.frame = control_frames[current_mg.control_type]
	
	next_sound.play()
	await get_tree().create_timer(1).timeout
	room_anim.play("zoom_in")
	add_child(current_mg)

	
func load_microgame(microgame : PackedScene):
	var inst = microgame.instantiate() as Microgame
	inst.finish_game.connect(on_microgame_done)
	inst.win_game.connect(func(): mg_won = true)
	inst.lose_game.connect(func(): pass) # losing doesnt change a win
	mg_won = false
	current_mg = inst
	

func on_microgame_done():
	# if not already won, look at the timeout setting
	var won = mg_won or (not current_mg.lose_on_timeout)
	
	room_anim.play("zoom_out")
	await room_anim.animation_finished
	unload_current_microgame()

	if won:
		print("Won game!")
		win_sound.play()
		score_anim.play("increment") # the animation increments the score
	else:
		print("Lost game!")	
		lose_sound.play()
		
	await get_tree().create_timer(1.75).timeout
	start_new_microgame()


func unload_current_microgame():
	current_mg.queue_free()
	current_mg = null


func increment_score():
	score += 1
	score_label.text = str(score)

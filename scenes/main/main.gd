extends Node2D
class_name Main

@export var microgames : Array[PackedScene]

var in_game : bool = false
var high_score : int = 0

var current_mg : Microgame
var mg_won : bool = false
var score : int = 0
var lives : int = 4
var time_scale : float = 1

# Room
@onready var room_anim = $RoomAnimations
@onready var win_sound = $Win
@onready var lose_sound = $Loss
@onready var next_sound = $Next

# UI
@onready var label_anim = $UI/Game/LabelAnimations
@onready var score_label = $UI/Game/ScoreLabel
@onready var lives_label = $UI/Game/LivesLabel
@onready var message_label = $UI/Game/MessageLabel
@onready var control_image = $UI/Game/ControlImage
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
	room_anim.play("change_to_message")
	
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
		label_anim.play("increment_score") # the animation calls increment_score()
	else:
		print("Lost game!")
		lose_sound.play()
		label_anim.play("lose_life") # the animation calls lose_life()
	
	await label_anim.animation_finished
	start_new_microgame()


func unload_current_microgame():
	current_mg.queue_free()
	current_mg = null


func increment_score():
	score += 1
	score_label.text = str(score)
	# TODO: add speedup

func lose_life():
	lives -= 1
	lives_label.text = "Lives: " + str(lives)
	# TODO: add game over 

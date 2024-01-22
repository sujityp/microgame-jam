extends AnimatedSprite2D

var direction = "down"
var d = Vector2(0,1)
var leg = "left"
@export var speed = 130


# Called when the node enters the scene tree for the first time.
func _ready():
	animation = "down_left"
	position = Vector2(648,88)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x < 180:
		position.x = 180
	elif position.x > 1070:
		position.x = 1070
	
	if position.y < 85:
		position.y = 85
	elif position.y > 715:
		position.y = 715


func _input(event):
	event
	if event.is_action_pressed("keyboard_down",false,false):
		direction = "down"
		d = Vector2(0,1)
		animation = direction+"_"+leg
		frame = 1
	elif event.is_action_pressed("keyboard_left",false,false):
		direction = "left"
		d = Vector2(-1,0)
		animation = direction+"_"+leg
		frame = 1
	elif event.is_action_pressed("keyboard_right",false,false):
		direction = "right"
		d = Vector2(1,0)
		animation = direction+"_"+leg
		frame = 1
	elif event.is_action_pressed("keyboard_up",false,false):
		direction = "up"
		d = Vector2(0,-1)
		animation = direction+"_"+leg
		frame = 1

	if event.is_action_pressed("keyboard_action", false, false):
		if leg == "right":
			leg = "left"
			animation = direction+"_"+leg
			frame = 0
			play()
			movement()
		elif leg == "left":
			leg = "right"
			animation = direction+"_"+leg
			frame = 0
			play()
			movement()


func movement():
	var velocity = d*speed
	position += velocity*0.2

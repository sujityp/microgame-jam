extends CharacterBody2D

const SPEED = 150

var direction_list = [1, -1]
var direction = direction_list[randi_range(0,1)]

var axis_list = ["x","y"]
var axis = axis_list[randi_range(0,1)]

# Makes sheep go in random directions
# either horizontally or vertically, OR in + or - directions

func _physics_process(delta):

	var animator = $AnimationPlayer
	var sheep = $Sprite_Sheep
	var collider = $CollisionShape2D
	
	# Each sheep should have its own animation player, sprite,
	# and collider associated with it.
	
	sheep.flip_h = false
	
	if axis == "x":
		
		if is_on_wall():
			direction  = direction*(-1)
			axis = axis_list[randi_range(0,1)]
			
		velocity.x = direction * SPEED
		
		animator.play("sheep_right")
		
		if direction == -1:
			sheep.flip_h = !sheep.flip_h
			
	elif axis == "y":
		
		if is_on_floor() or is_on_ceiling():
			direction  = direction*(-1)
			axis = axis_list[randi_range(0,1)]
		
		velocity.y = direction * SPEED
		
		if direction == 1:
			animator.play("sheep_towards")
			
		elif direction == -1:
			animator.play("sheep_away")
			
	move_and_slide()

extends CharacterBody2D
class_name Frog

var dead = false
var WALK_SPEED = 1000

func _physics_process(delta):
	var dir = Input.get_axis("keyboard_left", "keyboard_right")
	velocity = Vector2(dir * WALK_SPEED, 0.0)
	move_and_slide()
		

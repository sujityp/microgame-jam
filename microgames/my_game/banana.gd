extends CharacterBody2D

@export var explosion : PackedScene

var FALL_SPEED = 250

func _physics_process(delta):
	velocity = Vector2.DOWN * FALL_SPEED
	move_and_slide()


func _on_area_2d_body_entered(body):
	create_explosion_at(body)
	body.dead = true
	body.scale = Vector2.ZERO

func create_explosion_at(thing : Node2D):
	var inst = explosion.instantiate() as Sprite2D
	add_child(inst)
	inst.global_position = thing.position

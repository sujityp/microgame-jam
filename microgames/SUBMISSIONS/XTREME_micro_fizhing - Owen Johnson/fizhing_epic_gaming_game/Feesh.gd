extends CharacterBody2D

@onready var mainChar = $BigGuyMainChar/Hook

@export var explosion : PackedScene

var vel_x = randf_range(300,450)
var vel_y = 0
@export var caught = false

func _ready():
	if randi_range(1,2) == 1:
		position.x = 0
	else:
		position.x = 1300
		vel_x = -vel_x
		$Sprite2D.flip_h = true
	position.y = randf_range(500,700)
	if randi_range(1,10) == 5:
		if randi_range(1,2) == 1:
			$AnimationPlayer.play("MongusFish")
		else:
			$AnimationPlayer.play("RockFish")
	else:
		$AnimationPlayer.play("RegFish")
	

func _physics_process(delta):
	if caught == false:
		vel_x += randf_range(-10,10)
		vel_y += randf_range(-100,100)
		velocity = Vector2(vel_x, randf_range(-50,50))
	else:
		velocity = Vector2.ZERO
		if Input.is_action_pressed("keyboard_up") and position.y >=50:
			position.y -= 300 * delta
		if Input.is_action_pressed("keyboard_down") and position.y <=700:
			position.y += 300 * delta
		if position.y <= 200:
			#create_explosion_at(self)
			queue_free()
			#scale = Vector2.ZERO
			#position.y = 300
		if (position.x < 0 or position.x > 1300) and not caught:
			queue_free()
	move_and_slide()

	
#func create_explosion_at(thing : Node2D):
	#var inst = explosion.instantiate() as Sprite2D
	#add_child(inst)
	#inst.global_position = thing.position



func _on_area_2d_body_exited(body):
	caught = false


func _on_area_2d_body_entered(body):
	pass


func _on_area_2d_area_entered(area):
	$Area2D/CollisionShape2D.scale.x = 1.5
	$CollisionShape2D.scale.x = 1.5
	$Area2D/CollisionShape2D.scale.y = 1.5
	$CollisionShape2D.scale.y = 1.5
	if $AnimationPlayer.current_animation == "MongusFish":
		$SFX.play()

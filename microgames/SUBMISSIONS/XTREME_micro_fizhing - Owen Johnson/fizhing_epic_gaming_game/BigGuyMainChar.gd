extends CharacterBody2D
var fishing = false
var fishOnHook = false
var hookVel = 500
var hookVelX = 500
var winner = false


@export var explosion : PackedScene

func _ready():
	position.x = randf_range(50,1250)
	$Hook/Hook/HookHitbox/Sprite2D.visible = false
func _draw():
	if fishing == true:
		draw_line(Vector2(30, 10), Vector2($Hook.position.x, $Hook.position.y), Color.BLACK, 2.0)
		
func _physics_process(delta):
	position.y = 100
	if fishOnHook == true:
		hookVel = 150
		hookVelX = 0
	else:
		hookVel = 200
		hookVelX = 200
	if fishing == false and fishOnHook == false and winner == false:
		$Hook/Hook/HookHitbox/Sprite2D.visible = false
		$Hook/Hook/HookHitbox.disabled = true
		var dir = Input.get_axis("keyboard_left", "keyboard_right")
		velocity = Vector2(dir * 750, 0.0)
		if (position.x < 0 and dir == -1) or (position.x > 1300 and dir == 1):
			velocity = Vector2(0.0, 0.0)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			$AnimationPlayer.play("Swag")
		elif !winner:
			$AnimationPlayer.play("Normal")
		else:
			$AnimationPlayer.play("Emote")
			
		
	elif winner == false:
		$Hook/Hook/HookHitbox.disabled = false
		$Hook/Hook/HookHitbox/Sprite2D.visible = true
		velocity = Vector2(0,0)
		if Input.is_action_pressed("keyboard_right") and $Hook.position.x <=100:
			$Hook.position.x += hookVelX * delta
		if Input.is_action_pressed("keyboard_left") and $Hook.position.x >=-100:
			$Hook.position.x -= hookVelX * delta
		if Input.is_action_pressed("keyboard_up") and $Hook.position.y >=50:
			$Hook.position.y -= hookVel * delta
		if Input.is_action_pressed("keyboard_down") and $Hook.position.y <=295:
			$Hook.position.y += hookVel * delta
		queue_redraw()
		
		
		
	
	if Input.is_action_just_pressed("keyboard_action") and not fishOnHook and not winner:
		if fishing == false:
			$AnimationPlayer.play("Fish")
			fishing = true
			$Hook.position.x = 50
			$Hook.position.y = 50
		else:
			$AnimationPlayer.play("Normal")
			fishing = false
			
	
		
	
	move_and_slide()

	

func create_explosion_at(thing : Node2D):
	var inst = explosion.instantiate() as Sprite2D
	add_child(inst)
	inst.global_position = thing.position
	
	
func _on_hook_body_entered(body):
	$Hook/Hook.scale.x += 1
	$Hook/Hook.scale.y += 1
	body.caught = true
	fishOnHook = true
	#body.scale = Vector2.ZERO
	


func _on_hook_body_exited(body):
	if $Hook/Hook.position.y < 50:
		fishOnHook = false
		$Hook/Hook/HookHitbox/Sprite2D.visible = false
		$Hook/Hook.scale.x = 1
		$Hook/Hook.scale.y = 1
		create_explosion_at(body)
		$AnimationPlayer.play("Emote")
		fishing = false
		winner = true
		scale.x = 3
	queue_redraw()

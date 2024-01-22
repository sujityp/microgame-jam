extends CharacterBody2D


const FRICTION = 300.0
const JUMP_VELOCITY = -1000.0
const STEP_JUMP_VELOCITY = -400.0
const STEP_VELOCITY = -1000.0

signal jumped

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 5000
var mouse_clicked = false
var alive = true

@onready var Explosion = preload("res://microgames/knight_game/explosion/explosion.tscn")
@onready var StepSFX = $Music/StepSFX
@onready var JumpSFX = $Music/JumpSFX


func _physics_process(delta):
	if alive:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle step.
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_on_floor() and not mouse_clicked:
			velocity.y = STEP_JUMP_VELOCITY
			mouse_clicked = true
			velocity.x = STEP_VELOCITY
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			mouse_clicked = false

		# friction in x
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		
		if Input.is_action_just_pressed("keyboard_action") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			emit_signal("jumped")

		move_and_slide()


func kill():
	velocity = Vector2.ZERO
	alive = false
	var inst = Explosion.instantiate()
	get_parent().add_child(inst)
	inst.global_position = self.global_position - Vector2(-30,120)
	self.hide()

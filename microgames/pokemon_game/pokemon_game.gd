extends Microgame

# UI elements
@onready var arrow = $Background/arrow;
@onready var pp1 = $Text/PP;
@onready var pp2 = $Text/PP2;
@onready var type = $Text/Type;
@onready var enemy = $Background/Enemy;
@onready var player = $Background/OurPokemon;
@onready var enemyName = $Text/Enemy;
@onready var enemyLvl = $Text/EnemyLVL;
@onready var explosion = preload("res://microgames/knight_game/explosion/explosion.tscn")

# Music
@onready var sfx = $Music/buttonSFX;

var canMove = true;
var id = 0;
var winningId;
# Used in updating enemy info
var winningIds = [2, 0, 3];
var pngFiles = ["res://microgames/pokemon_game/pokemon_sprites/oddish.png", "res://microgames/pokemon_game/pokemon_sprites/machoke.png", "res://microgames/pokemon_game/pokemon_sprites/dragonite.png"];
var enemyNames = ["ODDISH", "MACHOKE", "DRAGONITE"]
var lvlNums = ["Lv 7", "Lv 31", "Lv 60"]
# Used in updating player info
var types = ["FLYING", "DRAGON", "FIRE", "DRAGON"];
var pp_used = ["35", "10", "15", "8"];
var pp_max = ["56", "16", "24", "10"];

# rng to determine enemy pokemon
func _ready():
	var rn = RandomNumberGenerator.new().randi() % 3;
	update_enemy(rn);
	super();

func create_explosion_at(thing : Node2D):
	var inst = explosion.instantiate() as Sprite2D
	add_child(inst)
	inst.position = thing.position
	
func win():
	sfx.play();
	create_explosion_at(enemy);
	enemy.visible = false;
	win_game.emit();
	
func lose():
	create_explosion_at(player);
	player.visible = false;
	lose_game.emit();

func update_enemy(num):
	winningId = winningIds[num];
	enemy.texture = load(pngFiles[num]);
	enemyName.text = enemyNames[num];
	enemyLvl = lvlNums[num];

func update_move(diff):
	sfx.play();
	id += diff;
	pp1.text = pp_used[id];
	pp2.text = pp_max[id];
	type.text = types[id];

func _process(delta):
	if canMove:
		if Input.is_action_pressed("keyboard_down") and arrow.position.y < 540:
			arrow.position.y = 540;
			update_move(2)
		elif Input.is_action_pressed("keyboard_up") and arrow.position.y > 505:
			arrow.position.y = 505;
			update_move(-2)
		elif Input.is_action_pressed("keyboard_right") and arrow.position.x < 535:
			arrow.position.x = 540;
			update_move(1)
		elif Input.is_action_pressed("keyboard_left") and arrow.position.x > 340:
			arrow.position.x = 340;
			update_move(-1)
		elif Input.is_action_just_pressed("keyboard_action"):
			canMove = false;
			if id == winningId:
				win();
			else:
				lose();

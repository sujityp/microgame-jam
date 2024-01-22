extends Microgame

var has_won = false


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	randomize()
	$Abra.position = Vector2(randf_range(262,986),randf_range(209,589))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_area_2d_area_entered(area):
	win_game.emit()
	has_won = true
	get_node("pokecenter_sound").play(0.7)
	get_node("Abra").hide()


func _on_bomb_timer_exploded():
	if has_won != true:
		get_node("teleport_sound").play()
		get_node("Abra").hide()

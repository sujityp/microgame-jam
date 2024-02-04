extends Microgame

var quantity
var counter = 0

var text_hide = true
var lose = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	super()
	randomize()
	
	var sheep1 = $SHEEP1
	var sheep2 = $SHEEP2
	var sheep3 = $SHEEP3
	var sheep4 = $SHEEP4
	var sheep5 = $SHEEP5
	var sheep6 = $SHEEP6
	var sheep7 = $SHEEP7
	var sheep8 = $SHEEP8
	var sheep9 = $SHEEP9
	var sheep10 = $SHEEP10
	
	# Bound to make a person sleepy.
	
	var sheeplist = [
		
		sheep1,
		sheep2,
		sheep3,
		sheep4,
		sheep5,
		sheep6,
		sheep7,
		sheep8,
		sheep9,
		sheep10
		
	]
	
	quantity = randi_range(5,10)
	
	for i in range(sheeplist.size()):
		
		if i <= (quantity - 1):
			pass
		
		elif i > (quantity - 1):
			sheeplist[i].hide()

func _process(_delta):
	
	var display = $DIGITIAL_TIMER/RichTextLabel
	
	var too_high_audio = $TOO_HIGH
	var too_high_text = $Went_Too_High
	
	var counter_string = str(counter)
	var sumstring = str(counter + quantity)
	
	if text_hide == true:
		too_high_text.hide()
		
	if Input.is_action_just_pressed("keyboard_action"):
			counter += 1
		
	if lose == false:
	
		if counter < 10:
			display.text = "0" + counter_string

		elif counter >= 10:
			display.text = counter_string
			
	elif lose == true: # meant to take a reset counter into account
		
		if (counter + quantity) < 10:
			display.text = "0" + sumstring

		elif (counter + quantity) >= 10:
			display.text = sumstring

	if (counter < quantity):
		lose_on_timeout = true
		
	elif (counter == quantity):
		lose_on_timeout = false
		
	elif (counter > quantity):
		
		if lose == false:
			too_high_audio.play()
			counter = 1
			
		elif lose == true:
			pass
		
		too_high_text.show()
			
		if text_hide:
			text_hide = !text_hide

		lose = true


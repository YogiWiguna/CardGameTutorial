extends MarginContainer

# Makes variable for database 
@onready var CardDatabase = preload("res://Assets/Cards/CardsDatabase.gd")
@onready var CardDatabaseTemp = CardDatabase.new()
# Get info from the CardsDatabase about the information of every character
var Cardname = 'Spearman'
@onready var CardInfo = CardDatabase.DATA[CardDatabaseTemp.get(Cardname)]
@onready var CardImg = str("res://Assets/Cards/",CardInfo[0],"/",Cardname,".png")

var startpos = Vector2()
var targetpos = Vector2()
var startrot = 0
var targetrot = 0
var t = 0
var DRAWTIME = 1
var ORGANISETIME = 0.5
@onready var Orig_scale = scale.x
enum{InHand,InPlay,InMouse,FocusInHand,MoveDrawnCardToHand,ReOrganiseHand}
var state = InHand
# Called when the node enters the scene tree for the first time.
func _ready():
#	print(CardInfo)
	# Replace with function body.
	
	#To make base of Card Size the process is :
	# CardSize is on spatical CardBase -> inspector -> size  
	var CardSize = size
	#And for the Border size(scale) Depends on the CardSize 
	# Why divide by Texture, because the border is a png and have a size
	$Border.scale *= CardSize/$Border.texture.get_size()
	#Card texture for load(call) the image and Card scale for make the image same with the CardSize
	$Card.texture = load(CardImg)
	$Card.scale *= CardSize/$Card.texture.get_size()
	$CardBack.scale *= CardSize/$CardBack.texture.get_size()
	
	#change the text on the cards depends on the database array
	var Attack = str(CardInfo[1])
	var Retaliation = str(CardInfo[2])
	var Health = str(CardInfo[3])
	var Cost = str(CardInfo[4])
	var Name = str(CardInfo[5])
	var SpecialText = str(CardInfo[6])
	
	#Set the name auto by calling from database and connect it from where the name place 
	# .text is where the text should change
	$Bars/TopBar/Name/CenterContainer/Name.text = Name
	$Bars/TopBar/Cost/CenterContainer/Cost.text = Cost
	$Bars/SpecialText/Text/CenterContainer/Type.text = SpecialText
	$Bars/BottomBar/Health/CenterContainer/Health.text = Health
	$Bars/BottomBar/Attack/CenterContainer/Attack.text = str(Attack,'/',Retaliation)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		InHand:
			pass
		InPlay:
			pass
		InMouse:
			pass
		FocusInHand:
			pass
		#Animate from the deck to myHand
		MoveDrawnCardToHand:
			if t <= 1: #always be a 1
				position = startpos.lerp(targetpos, t)
				rotation = startrot * (1-t) + targetrot*t
				scale.x = Orig_scale * abs(2*t - 1) #same as abs (1 - 2*t)
				if $CardBack.visible:
					if t >= 0.5:
						$CardBack.visible = false
				t += delta/float(DRAWTIME)
			else: 
				position = targetpos
				rotation = targetrot
				state = InHand
				t = 0
		ReOrganiseHand:
			if t <= 1: #always be a 1
				position = startpos.lerp(targetpos, t)
				rotation = startrot * (1-t) + targetrot*t
				t += delta/float(ORGANISETIME)
			else: 
				position = targetpos
				rotation = targetrot
				state = InHand
				t = 0
	

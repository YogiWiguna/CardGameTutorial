extends MarginContainer

# Makes variable for database 
@onready var CardDatabase = preload("res://Assets/Cards/CardsDatabase.gd")
# Get info from the CardsDatabase about the information of every character
var Cardname = 'Archer'
@onready var CardIndex = CardDatabase[Cardname]
@onready var CardInfo = CardDatabase.DATA[CardIndex]

@onready var CardImg = str("res://Assets/Cards/",CardInfo[0],"/",Cardname,".png")
# Called when the node enters the scene tree for the first time.
func _ready():
	print(CardInfo)# Replace with function body.
	
	#To make base of Card Size the process is :
	# CardSize is on spatical CardBase -> inspector -> size  
	var CardSize = size
	#And for the Border size(scale) Depends on the CardSize 
	# Why divide by Texture, because the border is a png and have a size
	$Border.scale *= CardSize/$Border.texture.get_size()
	#Card texture for load(call) the image and Card scale for make the image same with the CardSize
	$Card.texture = load(CardImg)
	$Card.scale *= CardSize/$Card.texture.get_size()
	
	#change the text on the cards depends on the database array
	var Attack = str(CardInfo[1])
	var Retaliation = str(CardInfo[2])
	var Health = str(CardInfo[3])
	var Cost = str(CardInfo[4])
	var SpecialText = str(CardInfo[6])
	
	#Set the name auto by calling from database and connect it from where the name place 
	# .text is where the text should change
	$Bars/TopBar/Name/CenterContainer/Name.text = Cardname
	$Bars/TopBar/Cost/CenterContainer/Cost.text = Cost
	$Bars/SpesialText/Name/CenterContainer/Type.text = SpecialText
	$Bars/BottomBar/Health/CenterContainer/Health.text = Health
	$Bars/BottomBar/Attack/CenterContainer/Attack.text = str(Attack,'/',Retaliation)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.


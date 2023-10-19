extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#CardSize to make the card when it call or draw. the card following the vector2
#Vector2 is vector for 2D,  (125,175) = (x,y) base from the middle point of CardBase Spatical
const CardSize = Vector2(125,175)

#CardBase preload is to call the cardbase.gd(Calling the cardbase function)
const CardBase = preload("res://Cards/CardBase.tscn") # loads card template
#PlayerHand preload is to call database CardList, when we draw a card or click a card it show up like the name on the PlayerHand.gd
const PlayerHand = preload("res://Cards/Player_Hand.gd")

#CardSelect is a place for a Cardlist random 
var CardSelected = []

@onready var DeckSize = PlayerHand.CardList.size()
var CardOffset = Vector2()
@onready var ViewportSize = Vector2(get_viewport().size)
@onready var CenterCardOval = ViewportSize * Vector2(0.5, 1.25)
@onready var Hor_rad = ViewportSize.x*0.45
@onready var Ver_rad = ViewportSize.y*0.4
var angle = 0
var Card_Numb = 0
var NumberCardsHand = 0
var CardSpread = 0.25
var OvalAngleVector = Vector2()
enum{InHand,InPlay,InMouse,FocusInHand,MoveDrawnCardToHand,ReOrganiseHand}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Input some event when click the leftclick it will show the card that we declare
func drawcard():
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instantiate()
	#random card. CardSelected is an emtpy array. The randi() is for random an array from the DeckSize
	#DeckSize 
	CardSelected = randi() % DeckSize
	new_card.Cardname = PlayerHand.CardList[CardSelected]
#	new_card.position = get_global_mouse_position()
	OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
	new_card.startpos = $Deck.position - CardSize/2
	new_card.targetpos = CenterCardOval + OvalAngleVector - CardSize
	new_card.startrot = 0
	#make card rotation side to side 
	# 180 = PI
	new_card.targetrot = (PI/2 - angle)/4
	#make halving the cars size
	new_card.scale *= CardSize/new_card.size
	
	new_card.state = MoveDrawnCardToHand
	Card_Numb = 0
	for Card in $Cards.get_children(): #Reorganise Hand
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - Card_Numb) 
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		
		Card.targetpos = CenterCardOval + OvalAngleVector - CardSize
		Card.startrot = Card.rotation
		Card.targetrot = (PI/2 - angle)/4
		
		Card_Numb += 1
		if Card.state == InHand:
			Card.state = ReOrganiseHand
			Card.startpos = Card.position
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.position)/(1-Card.t))
	
		
	$Cards.add_child(new_card)
	
	#erase the drawcard and the drawcard will be going to PlayerHand 
	PlayerHand.CardList.erase(PlayerHand.CardList[CardSelected])
	angle += 0.25
	DeckSize -= 1
	NumberCardsHand += 1
#	Card_Numb += 1
	return DeckSize

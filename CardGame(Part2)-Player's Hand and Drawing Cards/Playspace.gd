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
@onready var DeckSize = PlayerHand.CardList
@onready var ViewportSize = Vector2(get_viewport().size)
@onready var CenterCardOval = ViewportSize * Vector2(0.5, 1.25)
@onready var Hor_rad = ViewportSize.x*0.45
@onready var Ver_rad = ViewportSize.y*0.4
var angle = deg_to_rad(90)- 0.5 
var OvalAngleVector = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Input some event when click the leftclick it will show the card that we declare
func drawcard():
		var new_card = CardBase.instantiate()
		#random card. CardSelected is an emtpy array. The randi() is for random an array from the DeckSize
		#DeckSize 
		CardSelected = randi() % DeckSize
		new_card.Cardname = PlayerHand.CardList[CardSelected]
#		new_card.position = get_global_mouse_position()
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		new_card.position = CenterCardOval + OvalAngleVector - new_card.size/2
		#make halving the cars size
		new_card.scale *= CardSize/new_card.size
		#make card rotation side to side 
		# 180 = PI
		new_card.rotation = (PI/2 - angle)/4 
		
		$Cards.add_child(new_card)
		
		#erase the drawcard and the drawcard will be going to PlayerHand 
		PlayerHand.CardList.erase(PlayerHand.CardList[CardSelected])
		angle += 0.25
		DeckSize -= 1
		return DeckSize

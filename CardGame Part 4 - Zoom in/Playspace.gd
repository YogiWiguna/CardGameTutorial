extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CardSize = Vector2(125,175)
const CardBase = preload("res://Cards/CardBase.tscn")
const PlayerHand = preload("res://Cards/Player_Hand.gd")
var CardSelected = []
@onready var DeckSize = PlayerHand.CardList.size()
var CardOffset = Vector2()
@onready var ViewportSize = Vector2(get_viewport().size)
@onready var CentreCardOval = ViewportSize * Vector2(0.5, 1.25)
@onready var Hor_rad = ViewportSize.x*0.45
@onready var Ver_rad = ViewportSize.y*0.4
var angle = 0
var Card_Numb = 0
var NumberCardsHand = 0
var CardSpread = 0.25
var OvalAngleVector = Vector2()
enum{ InHand, InPlay, InMouse, FocusInHand, MoveDrawnCardToHand, ReOrganiseHand}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
@onready var DeckPosition = $Deck.position
func drawcard():
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instantiate()
	CardSelected = randi() % DeckSize
	new_card.Cardname = PlayerHand.CardList[CardSelected]
#	new_card.rect_position = get_global_mouse_position() 
	OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
	new_card.position = DeckPosition - CardSize/2
	new_card.targetpos = CentreCardOval + OvalAngleVector - CardSize
	new_card.Cardpos = new_card.targetpos
	new_card.startrot = 0
	new_card.targetrot = (PI/2 - angle)/4
	new_card.scale *= CardSize/new_card.size
	new_card.state = MoveDrawnCardToHand
	new_card.Card_Numb = NumberCardsHand
	Card_Numb = 0
	for Card in $Cards.get_children(): # reorganise hand
		angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - Card_Numb)
		OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
		
		Card.targetpos = CentreCardOval + OvalAngleVector - CardSize
		Card.Cardpos = Card.targetpos # Card default position
		Card.startrot = Card.rotation
		Card.targetrot = (PI/2 - angle)/4
		
		Card.Card_Numb = Card_Numb
		Card_Numb += 1
		if Card.state == InHand:
			Card.setup = true 
			Card.state = ReOrganiseHand
			Card.startpos = Card.position
		elif Card.state == MoveDrawnCardToHand:
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.position)/(1-Card.t))
	$Cards.add_child(new_card)
	PlayerHand.CardList.erase(PlayerHand.CardList[CardSelected])
	angle += 0.25
	DeckSize -= 1
	NumberCardsHand += 1
#	Card_Numb += 1
	return DeckSize

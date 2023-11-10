extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CardSize = Vector2(125,175)
const CardBase = preload("res://Cards/CardBase.tscn")
const PlayerHand = preload("res://Cards/Player_Hand.gd")
const CardSlot = preload("res://Cards/CardSlot.tscn")
var CardSelected = []
@onready var DeckSize = PlayerHand.CardList.size()
var CardOffset = Vector2()
@onready var ViewportSize = Vector2(get_viewport().size)
@onready var CentreCardOval = ViewportSize * Vector2(0.5, 1.25)
@onready var Hor_rad = ViewportSize.x*0.45
@onready var Ver_rad = ViewportSize.y*0.4
var angle = 0
var Card_Numb = 0
var NumberCardsHand = -1
var CardSpread = 0.25
var OvalAngleVector = Vector2()
enum{ InHand, InPlay, InMouse, FocusInHand, MoveDrawnCardToHand, ReOrganiseHand, MoveDrawnCardToDiscard}

var CardSlotEmpty = []
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Enemies/Enemy.visible = true
	$Enemies/Enemy.position = get_viewport().size * 0.4 + Vector2(200,0)
	$Enemies/Enemy.scale *= 0.3
	var NewSlot = CardSlot.instantiate()
	NewSlot.position = get_viewport().size * 0.4
	NewSlot.size = CardSize
	$CardSlots.add_child(NewSlot)
	CardSlotEmpty.append(true)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
@onready var DeckPosition = $Deck.position
@onready var DiscardPosition = $Discard.position
func drawcard():
	angle = PI/2 + CardSpread*(float(NumberCardsHand)/2 - NumberCardsHand)
	var new_card = CardBase.instantiate()
	CardSelected = randi() % DeckSize
	new_card.Cardname = PlayerHand.CardList[CardSelected]
	new_card.position = DeckPosition - CardSize/2
	new_card.DiscardPile = DiscardPosition - CardSize/2
	new_card.scale *= CardSize/new_card.size
	new_card.state = MoveDrawnCardToHand

	Card_Numb = 0
	
	$Cards.add_child(new_card)
	PlayerHand.CardList.erase(PlayerHand.CardList[CardSelected])
	angle += 0.25
	DeckSize -= 1
	NumberCardsHand += 1
#	Card_Numb += 1
	OrganiseHand()
	return DeckSize

func ReParentCard(CardNo):
	NumberCardsHand -= 1
	Card_Numb = 0
	var Card = $Cards.get_child(CardNo)
	$Cards.remove_child(Card)
	$CardsInPlay.add_child(Card)
	OrganiseHand()

func OrganiseHand():
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

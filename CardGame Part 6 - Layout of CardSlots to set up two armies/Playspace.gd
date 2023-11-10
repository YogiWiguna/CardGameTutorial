extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CardSize = Vector2(125,175)*0.6
const CardBase = preload("res://Cards/CardBase.tscn")
const PlayerHand = preload("res://Cards/Player_Hand.gd")
const CardSlot = preload("res://Cards/CardSlot.tscn")
var CardSelected = []
@onready var DeckSize = PlayerHand.CardList.size()
var CardOffset = Vector2()
@onready var ViewportSize = Vector2(get_viewport().size)
@onready var CentreCardOval = ViewportSize * Vector2(0.5, 1.32)
@onready var Hor_rad = ViewportSize.x*0.45
@onready var Ver_rad = ViewportSize.y*0.4
var angle = 0
var Card_Numb = 0
var NumberCardsHand = -1
var CardSpread = 0.002*CardSize.x
var OvalAngleVector = Vector2()
enum{ InHand, InPlay, InMouse, FocusInHand, MoveDrawnCardToHand, ReOrganiseHand, MoveDrawnCardToDiscard}

var CardSlotEmpty = []

var NumberColumns = 2
var NumberRows = 5
var CardSlotsPerSlide = NumberColumns*NumberRows
@onready var ViewPortSize = get_viewport().size
@onready var OuterxMargin = ViewPortSize.x/25
@onready var OuteryMargin = ViewPortSize.y/25
@onready var MiddlexMargin = ViewPortSize.x/10
@onready var CardZoneHeight = ViewPortSize.y - (CentreCardOval.y - CardSize.y - Ver_rad)# max height of card zone
@onready var CardSlotyGaps = ViewPortSize.y/40
@onready var CardSlotxGaps = ViewPortSize.x/40
@onready var CardSlotBaseWidth =  ViewPortSize.x/10
@onready var CardSlotTotalHeight = ViewPortSize.y - OuteryMargin - CardZoneHeight
@onready var CardSlotTotalWidth = ViewPortSize.x/2 - OuterxMargin - MiddlexMargin/2 - CardSlotBaseWidth  ##### only for one side
@onready var HeightforCard = (CardSlotTotalHeight - (NumberRows - 1)*CardSlotyGaps)/NumberRows
@onready var WidthforCard = (CardSlotTotalWidth - (NumberColumns - 1)*CardSlotxGaps)/NumberColumns
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in range(2): #both sets of player
		for j in range(NumberColumns):
			for k in range(NumberRows):
				var NewSlot = CardSlot.instantiate()
				NewSlot.size = Vector2(CardSize.y, CardSize.x)
				NewSlot.position = Vector2(OuterxMargin + CardSlotBaseWidth, OuteryMargin) + k*Vector2(0,HeightforCard + CardSlotyGaps) \
					+ j* Vector2(CardSlotTotalWidth/NumberColumns,0) + i*Vector2(CardSlotTotalWidth + MiddlexMargin,0)
				NewSlot.scale *= (HeightforCard/NewSlot.size.y)
				$CardSlots.add_child(NewSlot)
				CardSlotEmpty.append(true)
				
				
				
	$Enemies/EnemyLeft.visible = true
	$Enemies/EnemyLeft/VBoxContainer/ImageContainer/Image.flip_h = true
	$Enemies/EnemyLeft.scale *= 0.3
	$Enemies/EnemyLeft.position = Vector2(OuterxMargin + CardSlotBaseWidth/2, CardSlotTotalHeight/2)- $Enemies/EnemyLeft.size*$Enemies/EnemyLeft.scale/2
	$Enemies/EnemyRight.visible = true
	$Enemies/EnemyRight/VBoxContainer/ImageContainer/Image.flip_h = true
	$Enemies/EnemyRight.scale *= 0.3
	$Enemies/EnemyRight.position = Vector2( ViewportSize.x - OuterxMargin - CardSlotBaseWidth/2, CardSlotTotalHeight/2) - $Enemies/EnemyRight.size*$Enemies/EnemyRight.scale/2


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
	new_card.position = DeckPosition
	new_card.DiscardPile = DiscardPosition
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
		
		Card.targetpos = CentreCardOval + OvalAngleVector - Vector2(0,CardSize.y)
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
			Card.t -= 0.1
			Card.startpos = Card.targetpos - ((Card.targetpos - Card.position)/(1-Card.t))

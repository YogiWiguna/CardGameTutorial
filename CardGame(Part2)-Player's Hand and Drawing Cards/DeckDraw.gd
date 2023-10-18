extends TextureButton


# Called when the node enters the scene tree for the first time.

#Infinity decksize (unlimited deck)
var Decksize = INF
func _ready():
	scale *= $'../../'.CardSize/size


func _gui_input(event):
	if Input.is_action_just_released("leftclick"):
		if Decksize > 0:
			Decksize = $'../../'.drawcard()
			if Decksize == 0:
				disabled = true

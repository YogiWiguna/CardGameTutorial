extends MarginContainer

var CurrentHealth = 10
var MaxHealth = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/ImageContainer/Image.scale *= $VBoxContainer/ImageContainer.custom_minimum_size/$VBoxContainer/ImageContainer/Image.texture.get_size()
	$VBoxContainer/Bar/TextureProgress.value = 100
	$VBoxContainer/Bar/Count/Background/Number.text = str(CurrentHealth)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ChangeHealth(Number):
	CurrentHealth -= Number
	$VBoxContainer/Bar/TextureProgress.value = 100*CurrentHealth/MaxHealth
	$VBoxContainer/Bar/Count/Background/Number.text = str(CurrentHealth)
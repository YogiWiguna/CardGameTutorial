extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	scale *= $'../../'.CardSize/size
	disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.

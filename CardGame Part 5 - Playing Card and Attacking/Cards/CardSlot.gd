extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.scale *= size/$Sprite2D.texture.get_size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

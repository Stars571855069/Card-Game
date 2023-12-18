extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func sigil_imageload(route:String):
	$MarginContainer/Sprite2D.texture=load(route)

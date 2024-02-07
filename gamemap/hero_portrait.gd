extends Node2D
@export var portrait_route:String


# Called when the node enters the scene tree for the first time.
func _ready():
	if portrait_route!=null:
		character_load(portrait_route)
	

func character_load(route:String):
	$PanelContainer/Sprite2D.texture=load(route)
	
	
func get_hurt(amount:int):
	$dmglabel.text="-"+String.num_int64(amount)
	$AnimationPlayer.play("get_hurt")
	
func get_heal(amount:int):
	$heallabel.text="+"+String.num_int64(amount)
	$AnimationPlayer.play("get_heal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

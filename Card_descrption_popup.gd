extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn():
	$AnimationPlayer.play("spawn")
	
func close():
	$AnimationPlayer.play("close")
	
func description_set(card_description:String):
	$ColorRect/RichTextLabel.text=""
	$ColorRect/RichTextLabel.clear()
	$ColorRect/RichTextLabel.append_text("[b]"+card_description+"[/b]")

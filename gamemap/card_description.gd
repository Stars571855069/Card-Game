extends Node2D

var clickstate:int=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	



func _on_button_pressed():
	if clickstate==1:
		print("used right click")
	else:
		print("used left click")
	pass
	



func _on_button_button_down():
	var dire=Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	if dire:
		print("Right click")
		clickstate=1
	else:
		print("Left click")
		clickstate=0
		
	pass # Replace with function body.
	
func description_set(card_description:String,card_name:String):
	$Label.text=card_name
	$RichTextLabel.text=""
	$RichTextLabel.clear()
	$RichTextLabel.append_text("[b]"+card_description+"[/b]")
	

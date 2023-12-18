extends Node2D

var cardname:String
var cardcost:int
var cardattack:int
var cardhealth:int
var cardinfo:String
var cardsprite:String
var cardslot:int
var card_index_when_pciked:int
var card_ability_sum:int
var is_right_click=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func card_folded_load(a):
	cardname=a.get("cardname")
	cardcost=a.get("cardcost")
	cardattack=a.get("cardattack")
	cardhealth=a.get("cardhealth")
	cardsprite=a.get("cardsprite")
	cardslot=a.get("cardslot")
	card_ability_sum=a.get("card_ability_sum")
	
	$manacostframe/manacostLabel.text=String.num_int64(cardcost)
	$nameframe/nameLabel.text=cardname



#func _on_card_control_mouse_entered():
#	var newpopup=load("res://cardtemplate/card_descrption_popup.tscn").instantiate()
#	$".".add_child(newpopup)
#	newpopup.name="cardinfo"
#	newpopup.description_set(cardname,card_ability_sum)
#	newpopup.spawn()
	



#func _on_card_control_mouse_exited():
#	get_node("cardinfo").queue_free()

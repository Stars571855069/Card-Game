extends Node2D

var cardname:String
var cardcost:int
var cardattack:int
var cardhealth:int
var cardinfo:String
var cardsprite:String
var cardslot:int
var card_index_when_pciked:int
var is_right_click=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func card_folded_load(a):
	cardname=a.get("cardname")
	cardcost=a.get("cardcost")
	cardattack=a.get("cardattack")
	cardhealth=a.get("cardhealth")
	cardinfo=a.get("cardinfo")
	cardsprite=a.get("cardsprite")
	cardslot=a.get("cardslot")
	#print(cardslot)
	
	$manacostframe/manacostLabel.text=String.num_int64(cardcost)
	$nameframe/nameLabel.text=cardname
	#get_node("ColorRect/cardattackframe/attacklabel").text=String.num_int64(cardattack)
	#get_node("ColorRect/cardhealthframe/healthlabel").text=String.num_int64(cardhealth)
	#get_node("ColorRect/cardinfoframe/textcontainer/infolabel").text=cardinfo
	#get_node("ColorRect/cardimageframe/CenterContainer/cardsprite").texture=load(cardsprite)
	#$ColorRect/cardimageframe/CenterContainer/cardsprite.scale.x=0.279
	#$ColorRect/cardimageframe/CenterContainer/cardsprite.scale.y=0.249
	pass


func _on_card_control_pressed():
	card_description_send()
	pass # Replace with function body.
	
func card_description_send():
	#var targetnode=$"//"
	#print("sending signal")
	var rootnode=get_node("/root/Gamemap")
	var rootnode2=get_node("/root/DeckCreateScene")
	if rootnode!=null:
		rootnode.card_description_display(cardinfo,cardname)
	else:
		rootnode2.card_description_display(cardinfo,cardname)
	#emit_signal("cardinfochange",cardinfo)
	#get_node("Gamemap").card_description_display(cardinfo)

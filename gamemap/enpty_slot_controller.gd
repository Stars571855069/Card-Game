extends Node2D

var slot_is_empty=true

#signal hand_remove_card(card:Node2D)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	if (Globalsetting.global_card_current_selected != null) and slot_is_empty and Globalsetting.current_mana>=Globalsetting.global_card_current_selected.cardcost and Globalsetting.player_turn==true:
		var played_card=Globalsetting.global_card_current_selected
		played_card.deactivatedcard()
		#Globalsetting.global_card_current_selected.removefromhand(played_card)
		#hand_remove_card.emit(played_card)
		$"../../..".remove_card_from_hand(Globalsetting.global_card_current_selected)
		#print(self.name)
		played_card.get_parent().remove_child(played_card)
		print(self.name)
		self.add_child(played_card)
		Globalsetting.current_mana-=Globalsetting.global_card_current_selected.cardcost
		played_card.position.x=10
		played_card.position.y=5
		Globalsetting.global_card_current_selected = null
		slot_is_empty=false
		
		

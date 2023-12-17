extends Node2D

var card_slot:Array=[]
var temp_deck_Slot:Array=[]
var card_selection_button:Array=[]

var card_add_position:Array=[]

var deckbase:Array=[]
# Called when the node enters the scene tree for the first time.
func _ready():
	card_slot.append($"Pending_cardslot 1/emptyslot1")
	card_slot.append($"Pending_cardslot 2/emptyslot2")
	card_slot.append($"Pending_cardslot 3/emptyslot3")
	card_selection_button.append($"ButtonSelect 1")
	card_selection_button.append($"ButtonSelect 2")
	card_selection_button.append($"ButtonSelect 3")
	$BGMPlayer.play()
	for index in Globalsetting.cardloadid:
		deckbase.append(Globalsetting.cardtemplate.get(index))
	loadcards()
	pass # Replace with function body.

func loadcards():
	print("loading cards")
	var temp=0
	while(temp<3):
		var slot_card=card_slot[temp].get_child(1)
		if slot_card!=null:
			print("remove card")
			card_slot[temp].get_child(1).queue_free()
		temp+=1
		
	#create a temp cardbase to load 3 different cards
	var temp_card_collection:Array=[]
	for index in Globalsetting.cardloadid:
		temp_card_collection.append(Globalsetting.cardtemplate.get(index))
	
	card_add_position.clear()
	if len(Globalsetting.player_global_deck)<30:
		var create_temp=0
		while(create_temp<3):
			var random_card_index=randi_range(0,len(temp_card_collection)-1)
			var new_card=load("res://cardtemplate/cardtemplate.tscn").instantiate()
			card_slot[create_temp].add_child(new_card)
			new_card.cardload(temp_card_collection[random_card_index])
			card_add_position.append(temp_card_collection[random_card_index])
			#new_card.card_index_when_pciked=temp_card_collection[random_card_index].card_index_when_pciked
			new_card.card_spawn()
			temp_card_collection.remove_at(random_card_index)
			new_card.position.x=8
			new_card.position.y=5
			create_temp+=1
	else:
		$infoLabel.text="用你的牌组进行战斗"
		$Button.visible=true
		$"Pending_cardslot 1".visible=false
		$"Pending_cardslot 2".visible=false
		$"Pending_cardslot 3".visible=false
		$"ButtonSelect 1".visible=false
		$"ButtonSelect 2".visible=false
		$"ButtonSelect 3".visible=false
		pass

func add_card_to_deck(card:Node2D,cardindex:int):
	var folded_card_frame=MarginContainer.new()
	$ScrollContainer/VBoxContainer.add_child(folded_card_frame)
	folded_card_frame.custom_minimum_size.x=200
	folded_card_frame.custom_minimum_size.y=35
	folded_card_frame.name="container"+card.name
	var card_added=load("res://gamemap/card_folded_in_deck.tscn").instantiate()
	card_added.card_folded_load(card)
	
	Globalsetting.player_global_deck.append(card_add_position[cardindex])
	folded_card_frame.add_child(card_added)
	$infoLabel2.text="牌组中的卡牌："+String.num_int64(len(Globalsetting.player_global_deck))+" 张"
	pass



func _on_button_select_1_pressed():
	if len(Globalsetting.player_global_deck)<30:
		var target_card=card_slot[0].get_child(1)
		card_slot[0].remove_child(target_card)
		add_card_to_deck(target_card,0)
		print("card 1 selected")
	loadcards()
	pass # Replace with function body.


func _on_button_select_2_pressed():
	if len(Globalsetting.player_global_deck)<30:
		var target_card=card_slot[1].get_child(1)
		card_slot[1].remove_child(target_card)
		add_card_to_deck(target_card,1)
		print("card 2 selected")
	loadcards()
	pass # Replace with function body.


func _on_button_select_3_pressed():
	if len(Globalsetting.player_global_deck)<30:
		var target_card=card_slot[2].get_child(1)
		card_slot[2].remove_child(target_card)
		add_card_to_deck(target_card,2)
		print("card 3 selected")
	loadcards()
	pass # Replace with function body.


func _on_button_pressed():
	Globalsetting.player_health=40
	Globalsetting.enemy_health=40
	Globalsetting.current_turn=0
	Globalsetting.mana_max_limit=10
	Globalsetting.max_mana=0
	Globalsetting.current_mana=0
	Globalsetting.player_turn=true
	get_tree().change_scene_to_file("res://gamemap/gamemap.tscn")
	pass # Replace with function body.

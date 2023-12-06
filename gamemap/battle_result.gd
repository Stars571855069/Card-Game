extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_button_pressed():
	get_tree().quit()


func _on_restart_button_pressed():
	Globalsetting.player_health=40
	Globalsetting.enemy_health=40
	Globalsetting.current_turn=0
	Globalsetting.mana_max_limit=10
	Globalsetting.max_mana=0
	Globalsetting.current_mana=0
	Globalsetting.player_turn=true
	Globalsetting.player_global_deck.clear()
	get_tree().change_scene_to_file("res://gamemap/deck_create_scene.tscn")

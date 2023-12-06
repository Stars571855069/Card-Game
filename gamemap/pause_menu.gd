extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	#var paused=Input.is_action_pressed("Esc")
	#if paused and get_tree().paused == true:
	#	print("unpaused")
	#	get_tree().paused = false
	#	self.visible=false


func _on_quit_button_pressed():
	get_tree().quit()


func _on_resume_button_pressed():
	print("Resumed")
	self.visible=false
	get_tree().paused = false
	
	#pass # Replace with function body.

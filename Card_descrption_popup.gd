extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if self.global_position.y<=0:
		self.position.y=-20

func relocate(type:String):
	if type=="folded":
		pass
	

func spawn():
	$AnimationPlayer.play("spawn")
	
func close():
	$AnimationPlayer.play("close")
	
func description_set(card_name:String,card_sigil:int):
	$ColorRect/RichTextLabel.text=""
	$ColorRect/RichTextLabel.clear()
	$ColorRect/cardname.text=card_name
	if card_sigil==0:
		$ColorRect/RichTextLabel.append_text("这张卡牌没有特殊效果")
	else:
		var temp_group:Array=[]
		var temp_divide=0
		var data_base10=card_sigil
		while(data_base10!=0):
			temp_divide=data_base10%2
			data_base10/=2
			temp_group.append(temp_divide)
	#sigil load in and create sigil sprite
		var groupindex=0
		for t in (temp_group):
			if(t==1):
				var imageroute=Globalsetting.global_sigil_image_route[groupindex]
				var description_template=Globalsetting.global_sigil_description_template[groupindex]
				$ColorRect/RichTextLabel.append_text("[img]"+imageroute+"[/img]:")
				$ColorRect/RichTextLabel.append_text("[b]"+card_name+"[/b]"+description_template)
				$ColorRect/RichTextLabel.newline()
			groupindex+=1

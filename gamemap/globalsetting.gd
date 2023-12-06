extends Node2D

var global_card_current_selected:Node2D
@export var player_health:int=40
@export var enemy_health:int=40
var current_turn:int=0
var mana_max_limit:int=10
var max_mana:int=0
var current_mana:int=0
var player_turn:bool=true

var player_global_deck:Array=[]

#---------card ability---------
#  0 = null
#  1 = Poisonous
#  2 = Devine Shield
#  4 = Triple Attack
#  8 = Give a random card when died
#  16 = Return to hand when died
#  32 = Leave a bomb when died
#  64 = Destroy opposite card when died
#  128 = Give a rabbit card when died
#-------------------------------

var global_sigil_image_route:Array=[
	"res://sigilsprite/sigil_poisonous.png",
	"res://sigilsprite/sigil_devineshield.png",
	"res://sigilsprite/sigil_tripleattack.png",
	"res://sigilsprite/sigil_givecarddied.png",
	"res://sigilsprite/sigil_returndied.png",
	"res://sigilsprite/sigil_leavebombdied.png",
	"res://sigilsprite/sigil_killcarddied.png",
	"res://sigilsprite/sigil_givecarddied.png"
]

enum cardloadid{
	card0,card1,card2,card3,card4,card5,card6,card7,card8,card9,card10,
	card11,card12,card13,card14,card15,card16,card17,card18,card19,card20
}

var cardtemplate: Dictionary ={
	"card0": {cardid=0,cardname="Aluna",cardcost= 3,cardattack = 1,cardhealth = 4,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardaluna.png",cardslot=0,cardability=3},
	"card1": {cardid=1,cardname="Kiiwata",cardcost= 2,cardattack = 2,cardhealth = 3,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardkiiwata.png",cardslot=0,cardability=0},
	"card2": {cardid=2,cardname="Chy",cardcost= 6,cardattack = 3,cardhealth = 8,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardchy.png",cardslot=0,cardability=0},
	"card3": {cardid=3,cardname="强盗",cardcost= 4,cardattack = 2,cardhealth = 5,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardbandit.png",cardslot=0,cardability=0},
	"card4": {cardid=4,cardname="眼镜蛇",cardcost= 2,cardattack = 1,cardhealth = 2,cardinfo = "攻击会消灭任何卡牌",cardsprite="res://cardsprite/cardsnake.png",cardslot=0,cardability=1},
	"card5": {cardid=5,cardname="符文魔像",cardcost= 9,cardattack = 6,cardhealth = 6,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardgolem.png",cardslot=0,cardability=0},
	"card6": {cardid=6,cardname="骷髅",cardcost= 0,cardattack = 1,cardhealth = 1,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardskeleton.png",cardslot=0,cardability=0},
	"card7": {cardid=7,cardname="强化陷阱",cardcost= 4,cardattack = 3,cardhealth = 3,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardtrap.png",cardslot=0,cardability=0},
	"card8": {cardid=8,cardname="野人",cardcost= 0,cardattack = 1,cardhealth = 1,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardwildcreature.png",cardslot=0,cardability=0},
	"card9": {cardid=9,cardname="民兵",cardcost= 6,cardattack = 6,cardhealth = 4,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardmillitia.png",cardslot=0,cardability=0},
	"card10": {cardid=10,cardname="鱼人",cardcost= 1,cardattack = 2,cardhealth = 1,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardmurloc.png",cardslot=0,cardability=0},
	"card11": {cardid=11,cardname="猎犬",cardcost= 4,cardattack = 3,cardhealth = 3,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardhound.png",cardslot=0,cardability=0},
	"card12": {cardid=12,cardname="狼",cardcost= 3,cardattack = 3,cardhealth = 2,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardwolf.png",cardslot=0,cardability=0},
	"card13": {cardid=13,cardname="多头蛇",cardcost= 6,cardattack = 2,cardhealth = 3,cardinfo = "可以同时攻击对手相邻的卡牌",cardsprite="res://cardsprite/cardhydra.png",cardslot=0,cardability=4},
	"card14": {cardid=14,cardname="猫头鹰",cardcost= 2,cardattack = 2,cardhealth = 4,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardowl.png",cardslot=0,cardability=0},
	"card15": {cardid=15,cardname="骡子",cardcost= 3,cardattack = 2,cardhealth = 3,cardinfo = "死亡后生效：随机获得一张卡牌",cardsprite="res://cardsprite/cardmule.png",cardslot=0,cardability=8},
	"card16": {cardid=16,cardname="活动假人",cardcost= 1,cardattack = 0,cardhealth = 1,cardinfo = "死亡后生效：获得一张新的‘活动假人’",cardsprite="res://cardsprite/carddummy.png",cardslot=0,cardability=16},
	"card17": {cardid=17,cardname="活着的毛皮",cardcost= 2,cardattack = 0,cardhealth = 4,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardpelts.png",cardslot=0,cardability=0},
	"card18": {cardid=18,cardname="十字军",cardcost= 5,cardattack = 4,cardhealth = 2,cardinfo = "免疫受到的第一次伤害",cardsprite="res://cardsprite/cardcrusader.png",cardslot=0,cardability=2},
	"card19": {cardid=19,cardname="机械陷阱",cardcost= 6,cardattack = 2,cardhealth = 5,cardinfo = "死亡后生效：在原地留下一个炸弹，炸弹会在死亡后摧毁对面的卡牌",cardsprite="res://cardsprite/cardmechtrap.png",cardslot=0,cardability=32},
	"card20": {cardid=20,cardname="螳螂",cardcost= 2,cardattack = 1,cardhealth = 3,cardinfo = "这张牌没有特殊效果",cardsprite="res://cardsprite/cardmantis.png",cardslot=0,cardability=0}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

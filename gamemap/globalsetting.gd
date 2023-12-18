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
#  256 = won't take damage form card has lower attack than itself
#-------------------------------

var global_sigil_image_route:Array=[
	"res://sigilsprite/sigil_poisonous.png",
	"res://sigilsprite/sigil_devineshield.png",
	"res://sigilsprite/sigil_tripleattack.png",
	"res://sigilsprite/sigil_givecarddied.png",
	"res://sigilsprite/sigil_returndied.png",
	"res://sigilsprite/sigil_leavebombdied.png",
	"res://sigilsprite/sigil_killcarddied.png",
	"res://sigilsprite/sigil_givecarddied.png",
	"res://sigilsprite/sigil_challenge.png"
]

var global_sigil_description_template:Array=[
	" 的攻击会消灭任何卡牌",
	" 免疫受到的第一次伤害",
	" 的攻击同时对目标相邻的卡牌造成伤害",
	" 在死亡时会给予一张新的卡牌",
	" 在死亡时会回到你的手牌",
	" 在死亡时会留下一个炸弹",
	" 在死亡时会消灭对面的卡牌",
	" 在死亡时会将一张兔子卡牌置入你的手牌",
	" 不会受到攻击力低于自身的卡牌的伤害"
]

enum cardloadid{
	card0,card1,card2,card3,card4,card5,card6,card7,card8,card9,card10,
	card11,card12,card13,card14,card15,card16,card17,card18,card19,card20
}

var cardtemplate: Dictionary ={
	"card0": {cardname="Aluna",cardrarity=3,cardcost= 3,cardattack = 1,cardhealth = 4,cardsprite="res://cardsprite/cardaluna.png",cardslot=0,cardability=3},
	"card1": {cardname="Kiiwata",cardrarity=3,cardcost= 2,cardattack = 2,cardhealth = 3,cardsprite="res://cardsprite/cardkiiwata.png",cardslot=0,cardability=256},
	"card2": {cardname="Chy",cardrarity=3,cardcost= 6,cardattack = 3,cardhealth = 8,cardsprite="res://cardsprite/cardchy.png",cardslot=0,cardability=0},
	"card3": {cardname="强盗",cardrarity=0,cardcost= 4,cardattack = 2,cardhealth = 5,cardsprite="res://cardsprite/cardbandit.png",cardslot=0,cardability=0},
	"card4": {cardname="眼镜蛇",cardrarity=0,cardcost= 2,cardattack = 1,cardhealth = 2,cardsprite="res://cardsprite/cardsnake.png",cardslot=0,cardability=1},
	"card5": {cardname="符文魔像",cardrarity=0,cardcost= 9,cardattack = 6,cardhealth = 6,cardsprite="res://cardsprite/cardgolem.png",cardslot=0,cardability=0},
	"card6": {cardname="骷髅",cardrarity=0,cardcost= 0,cardattack = 1,cardhealth = 1,cardsprite="res://cardsprite/cardskeleton.png",cardslot=0,cardability=0},
	"card7": {cardname="强化陷阱",cardrarity=0,cardcost= 4,cardattack = 3,cardhealth = 3,cardsprite="res://cardsprite/cardtrap.png",cardslot=0,cardability=0},
	"card8": {cardname="野人",cardrarity=0,cardcost= 0,cardattack = 1,cardhealth = 1,cardsprite="res://cardsprite/cardwildcreature.png",cardslot=0,cardability=0},
	"card9": {cardname="民兵",cardrarity=0,cardcost= 6,cardattack = 6,cardhealth = 4,cardsprite="res://cardsprite/cardmillitia.png",cardslot=0,cardability=0},
	"card10": {cardname="鱼人",cardrarity=0,cardcost= 1,cardattack = 2,cardhealth = 1,cardsprite="res://cardsprite/cardmurloc.png",cardslot=0,cardability=0},
	"card11": {cardname="猎犬",cardrarity=0,cardcost= 4,cardattack = 3,cardhealth = 3,cardsprite="res://cardsprite/cardhound.png",cardslot=0,cardability=0},
	"card12": {cardname="狼",cardrarity=0,cardcost= 3,cardattack = 3,cardhealth = 2,cardsprite="res://cardsprite/cardwolf.png",cardslot=0,cardability=0},
	"card13": {cardname="多头蛇",cardrarity=0,cardcost= 6,cardattack = 2,cardhealth = 3,cardsprite="res://cardsprite/cardhydra.png",cardslot=0,cardability=4},
	"card14": {cardname="猫头鹰",cardrarity=0,cardcost= 2,cardattack = 2,cardhealth = 4,cardsprite="res://cardsprite/cardowl.png",cardslot=0,cardability=0},
	"card15": {cardname="骡子",cardrarity=0,cardcost= 3,cardattack = 2,cardhealth = 3,cardsprite="res://cardsprite/cardmule.png",cardslot=0,cardability=8},
	"card16": {cardname="活动假人",cardrarity=0,cardcost= 1,cardattack = 0,cardhealth = 1,cardsprite="res://cardsprite/carddummy.png",cardslot=0,cardability=16},
	"card17": {cardname="活着的毛皮",cardrarity=0,cardcost= 2,cardattack = 0,cardhealth = 4,cardsprite="res://cardsprite/cardpelts.png",cardslot=0,cardability=0},
	"card18": {cardname="十字军",cardrarity=0,cardcost= 5,cardattack = 4,cardhealth = 2,cardsprite="res://cardsprite/cardcrusader.png",cardslot=0,cardability=2},
	"card19": {cardname="机械陷阱",cardrarity=0,cardcost= 6,cardattack = 2,cardhealth = 5,cardsprite="res://cardsprite/cardmechtrap.png",cardslot=0,cardability=32},
	"card20": {cardname="螳螂",cardrarity=0,cardcost= 2,cardattack = 1,cardhealth = 3,cardsprite="res://cardsprite/cardmantis.png",cardslot=0,cardability=0}
}



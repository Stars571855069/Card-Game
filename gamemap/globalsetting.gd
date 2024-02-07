extends Node2D

var global_card_current_selected:Node2D
@export var player_health:int=40
@export var enemy_health:int=40
var player_health_limit:int=40
var enemy_health_limit:int=40
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
#  512 = died after attacked
#  1024 = gain +1 attack after kill a card
#  2048 = draw a card when died
#  4096 = heal to full when survived damage
#  8192 = heal player when attack
#  16384 = immune to poisonous
#  32768
#  65536
#  131072
#-------------------------------

var global_sigil_image_route:Array=[
	"res://resource/image/sigilsprite/sigil_poisonous.png",
	"res://resource/image/sigilsprite/sigil_devineshield.png",
	"res://resource/image/sigilsprite/sigil_tripleattack.png",
	"res://resource/image/sigilsprite/sigil_givecarddied.png",
	"res://resource/image/sigilsprite/sigil_returndied.png",
	"res://resource/image/sigilsprite/sigil_leavebombdied.png",
	"res://resource/image/sigilsprite/sigil_killcarddied.png",
	"res://resource/image/sigilsprite/sigil_givecarddied.png",
	"res://resource/image/sigilsprite/sigil_challenge.png",
	"res://resource/image/sigilsprite/sigil_brittle.png",
	"res://resource/image/sigilsprite/sigil_devour.png",
	"res://resource/image/sigilsprite/sigil_drawcarddied.png",
	"res://resource/image/sigilsprite/sigil_healing.png",
	"res://resource/image/sigilsprite/sigil_lifesteal.png",
	"res://resource/image/sigilsprite/sigil_rocksolid.png"
	
]

var global_sigil_description_template:Array=[
	"的攻击会消灭任何卡牌",
	"免疫受到的第一次伤害",
	"的攻击同时对目标相邻的卡牌造成伤害（还没做好）",
	"在死亡时会给予一张新的卡牌",
	"在死亡时会回到你的手牌",
	"在死亡时会留下一个炸弹（还没做好）",
	"在死亡时会消灭对面的卡牌（还没做好）",
	"在死亡时会将一张兔子卡牌置入你的手牌（还没做好）",
	"不会受到攻击力低于自身的卡牌的伤害（还没做好）",
	"在攻击后会死亡（还没做好）",
	"在消灭一张卡牌后会获得+1攻击（还没做好）",
	"在死亡时会抽1张牌（还没做好）",
	"在攻击后如果没有死亡,会回复所有生命值（还没做好）",
	"的攻击伤害会为玩家回复等量生命",
	"对剧毒伤害免疫（还没做好）"
]

enum cardloadid{
	card0,card1,card2,card3,card4,card5,card6,card7,card8,card9,card10,
	card11,card12,card13,card14,card15,card16,card17,card18,card19,card20,
	card21,card22,card23,card24,card25,card26,card27
}

var cardtemplate: Dictionary ={
	"card0": {cardid=0,cardname="Aluna",cardrarity=3,cardcost= 3,cardattack = 1,cardhealth = 4,cardsprite="res://resource/image/cardsprite/cardaluna.png",cardslot=0,cardability=3},
	"card1": {cardid=1,cardname="Kiiwata",cardrarity=3,cardcost= 2,cardattack = 2,cardhealth = 3,cardsprite="res://resource/image/cardsprite/cardkiiwata.png",cardslot=0,cardability=256},
	"card2": {cardid=2,cardname="Chy",cardrarity=3,cardcost= 6,cardattack = 3,cardhealth = 8,cardsprite="res://resource/image/cardsprite/cardchy.png",cardslot=0,cardability=8192},
	"card3": {cardid=3,cardname="强盗",cardrarity=0,cardcost= 4,cardattack = 2,cardhealth = 5,cardsprite="res://resource/image/cardsprite/cardbandit.png",cardslot=0,cardability=0},
	"card4": {cardid=4,cardname="眼镜蛇",cardrarity=0,cardcost= 2,cardattack = 1,cardhealth = 2,cardsprite="res://resource/image/cardsprite/cardsnake.png",cardslot=0,cardability=1},
	"card5": {cardid=5,cardname="符文魔像",cardrarity=0,cardcost= 9,cardattack = 6,cardhealth = 6,cardsprite="res://resource/image/cardsprite/cardgolem.png",cardslot=0,cardability=0},
	"card6": {cardid=6,cardname="骷髅",cardrarity=0,cardcost= 0,cardattack = 1,cardhealth = 1,cardsprite="res://resource/image/cardsprite/cardskeleton.png",cardslot=0,cardability=0},
	"card7": {cardid=7,cardname="强化陷阱",cardrarity=0,cardcost= 4,cardattack = 3,cardhealth = 3,cardsprite="res://resource/image/cardsprite/cardtrap.png",cardslot=0,cardability=0},
	"card8": {cardid=8,cardname="野人",cardrarity=0,cardcost= 0,cardattack = 1,cardhealth = 1,cardsprite="res://resource/image/cardsprite/cardwildcreature.png",cardslot=0,cardability=0},
	"card9": {cardid=9,cardname="民兵",cardrarity=0,cardcost= 4,cardattack = 3,cardhealth = 4,cardsprite="res://resource/image/cardsprite/cardmillitia.png",cardslot=0,cardability=0},
	"card10": {cardid=10,cardname="鱼人",cardrarity=0,cardcost= 1,cardattack = 2,cardhealth = 1,cardsprite="res://resource/image/cardsprite/cardmurloc.png",cardslot=0,cardability=0},
	"card11": {cardid=11,cardname="猎犬",cardrarity=0,cardcost= 4,cardattack = 2,cardhealth = 3,cardsprite="res://resource/image/cardsprite/cardhound.png",cardslot=0,cardability=8192},
	"card12": {cardid=12,cardname="狼",cardrarity=0,cardcost= 3,cardattack = 3,cardhealth = 2,cardsprite="res://resource/image/cardsprite/cardwolf.png",cardslot=0,cardability=0},
	"card13": {cardid=13,cardname="多头蛇",cardrarity=0,cardcost= 6,cardattack = 2,cardhealth = 3,cardsprite="res://resource/image/cardsprite/cardhydra.png",cardslot=0,cardability=4},
	"card14": {cardid=14,cardname="猫头鹰",cardrarity=0,cardcost= 2,cardattack = 2,cardhealth = 4,cardsprite="res://resource/image/cardsprite/cardowl.png",cardslot=0,cardability=0},
	"card15": {cardid=15,cardname="骡子",cardrarity=0,cardcost= 3,cardattack = 2,cardhealth = 3,cardsprite="res://resource/image/cardsprite/cardmule.png",cardslot=0,cardability=8},
	"card16": {cardid=16,cardname="活动假人",cardrarity=0,cardcost= 1,cardattack = 0,cardhealth = 1,cardsprite="res://resource/image/cardsprite/carddummy.png",cardslot=0,cardability=16},
	"card17": {cardid=17,cardname="活着的毛皮",cardrarity=0,cardcost= 2,cardattack = 0,cardhealth = 4,cardsprite="res://resource/image/cardsprite/cardpelts.png",cardslot=0,cardability=0},
	"card18": {cardid=18,cardname="十字军",cardrarity=0,cardcost= 5,cardattack = 4,cardhealth = 2,cardsprite="res://resource/image/cardsprite/cardcrusader.png",cardslot=0,cardability=2},
	"card19": {cardid=19,cardname="机械陷阱",cardrarity=0,cardcost= 6,cardattack = 2,cardhealth = 5,cardsprite="res://resource/image/cardsprite/cardmechtrap.png",cardslot=0,cardability=32},
	"card20": {cardid=20,cardname="螳螂",cardrarity=0,cardcost= 2,cardattack = 1,cardhealth = 3,cardsprite="res://resource/image/cardsprite/cardmantis.png",cardslot=0,cardability=0},
	"card21": {cardid=21,cardname="易碎的雕像",cardrarity=1,cardcost= 2,cardattack = 1,cardhealth = 2,cardsprite="res://resource/image/cardsprite/cardfragilgolem.png",cardslot=0,cardability=512},
	"card22": {cardid=22,cardname="暴戾的食尸鬼",cardrarity=0,cardcost= 4,cardattack = 1,cardhealth = 5,cardsprite="res://resource/image/cardsprite/cardghoul.png",cardslot=0,cardability=1024},
	"card23": {cardid=23,cardname="招财猫",cardrarity=0,cardcost= 2,cardattack = 1,cardhealth = 2,cardsprite="res://resource/image/cardsprite/cardmoneycat.png",cardslot=0,cardability=2048},
	"card24": {cardid=24,cardname="老道的牧师",cardrarity=0,cardcost= 4,cardattack = 1,cardhealth = 3,cardsprite="res://resource/image/cardsprite/cardpriest.png",cardslot=0,cardability=4096},
	"card25": {cardid=25,cardname="吸血鬼",cardrarity=0,cardcost= 6,cardattack = 2,cardhealth = 4,cardsprite="res://resource/image/cardsprite/cardvampire.png",cardslot=0,cardability=8192},
	"card26": {cardid=26,cardname="坚固的岩石",cardrarity=0,cardcost= 3,cardattack = 1,cardhealth = 8,cardsprite="res://resource/image/cardsprite/cardrock.png",cardslot=0,cardability=16384},
	"card27": {cardid=27,cardname="附魔的符文石",cardrarity=1,cardcost= 8,cardattack = 2,cardhealth = 7,cardsprite="res://resource/image/cardsprite/cardrunewithspike.png",cardslot=0,cardability=8193}
}



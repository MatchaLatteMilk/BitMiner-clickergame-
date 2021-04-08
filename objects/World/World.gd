extends Node2D

onready var pparticle = preload("res://objects/Particle/Plus_Particle.tscn")
onready var pc_button = $UI/Upgrade/PC_Count/U_PC
onready var gc_button = $UI/Upgrade/Graphic_Card/U_GC


enum {MENU,PLAY}
var state = PLAY
#score variable
var money: float
var btc: float

#InUse variable
var money_per_click = 1

#Upgrade variable
var PC_status = 1
var GCard_status = 1
var PC_Price = 100
var GCard_price = 20

export var btc_price_usd = 57665

func _ready():
	signal_check()
	randomize()
	get_tree().set_auto_accept_quit(false)

func _physics_process(delta):
	$Money_Label.text = "$ " + str(money)
	$Bitcoin_Label.text = str(money/btc_price_usd) + " BTC"
	change_upgrade_label()
	upgrade_check()
	status_check()

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed() and state == PLAY:
		click_particle()

#SIGNAL FUNCTION
func signal_check():
	$UI/HBoxContainer/Upgrade_Button.connect("pressed", self,"on_button_upgrade_pressed")
	$UI/Upgrade/Close.connect("pressed", self,"on_button_close_pressed")
	$UI/Option/Close.connect("pressed", self,"on_button_close_pressed")
	$UI/Option/OptionButton.connect("item_selected",self,"on_color_picked")
	$UI/HBoxContainer/Option_Button.connect("pressed", self,"on_button_option_pressed")
	$UI/Upgrade/Graphic_Card/U_GC.connect("pressed",self,"on_gc_upgrade")
	$UI/Upgrade/PC_Count/U_PC.connect("pressed",self,"on_pc_upgrade")

#LABEL FUNCTION
func change_upgrade_label():
	$UI/Upgrade/Graphic_Card/U_GC.text = "LEVEL " + str(GCard_status) + " | $" + str(GCard_price)
	$UI/Upgrade/PC_Count/U_PC.text = "LEVEL " + str(PC_status) + " | $" + str(PC_Price)

#ANOMALIES FUNCTION
func change_state(obj):
	state = obj

#PARTICLE FUNCTION
func click_particle():
	for n in PC_status:
		var click = pparticle.instance()
		click.position = Vector2(rand_range(100,610),rand_range(380,900))
		click.get_node("Label").text = "+" + str(money_per_click)
		get_node("PARTICLE").add_child(click)
		money += money_per_click
		$PewAudio.play()

#UPGRADE FUNCTION
func upgrade_check():
	if money >= PC_Price:
		pc_button.disabled = false
	else:
		pc_button.disabled = true
	if money >= GCard_price:
		gc_button.disabled = false
	else:
		gc_button.disabled = true

func status_check():
	money_per_click = GCard_status

#SIGNAL_CHANGE_FUNCTION ===================================================
func on_color_picked(number):
	match number:
		0:
			$ColorRect.color = Color('024959')
		1:
			$ColorRect.color = Color('BF5B04')
		2:
			$ColorRect.color = Color('D9B29C')
		3:
			$ColorRect.color = Color('A66249')
		4:
			$ColorRect.color = Color('8C0303')

func on_button_upgrade_pressed():
	change_state(MENU)
	$UI/Upgrade.show()

func on_button_option_pressed():
	change_state(MENU)
	$UI/Option.show()

func on_button_close_pressed():
	change_state(PLAY)
	$UI/Upgrade.hide()
	$UI/Option.hide()

func on_pc_upgrade():
	money -= PC_Price
	PC_Price = PC_Price * rand_range(1.5,3.5)
	PC_status += 1
	$PingPong.play()

func on_gc_upgrade():
	money -= GCard_price
	GCard_price = GCard_price * rand_range(1.5,3.5)
	GCard_status += 1
	$PingPong.play()

#SAVE FUNCTION
#func save():
#	var save_node = get_tree().get_nodes_in_group("Persist")
#	for i in save_node:
#		save_file()
#
#func save_file():
#	var save_dict = {
#		"filename": get_filename(),
#		"money": $Money_Label.text,
#		"bitcoin": $Bitcoin_Label.text
#	}
#	return save_dict
#
#func save_game_file():
#	var save_game = File.new()
#	save_game.open("user://savegame.save", File.WRITE)
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for node in save_nodes:
#		if node.filename.empty():
#			print("persistent node is not an instanced scene")
#			continue
#		if !node.has_method("save"):
#			print("persistent node is missing a save() function")
#			continue
#		var node_data = node.call("save")
#		save_game.store_line(to_json(node_data))
#	save_game.close()

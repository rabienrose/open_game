extends Node

signal input_choose_card(btn_index)
signal get_new_frame(frame_dat)

var rng
var map_size=40
var tile_size=150
var config_folder="config"
var card_infos={}
var max_card_rate_point=0
var h_posion_lv=[20,14,7,3,0]
var safe_area_lv=[14,7,3,0,0]
var tile_cell_table=[0,1,5,6,7]

func on_input_choose_card(btn_index):
	var frame_dat={}
	frame_dat["card_choose"]=btn_index
	emit_signal("get_new_frame",frame_dat)

func _ready():
	rng = RandomNumberGenerator.new()
	load_card_infos()
	connect("input_choose_card", self, "on_input_choose_card")
	# rng.randomize()

func check_unit_valid(unit):
	if is_instance_valid(unit) and unit.dead==false:
		return true
	else:
		return false

func rand_pick_cards():
	var ret_cards=[]
	var card_have={}
	while true:
		var rand_i = rng.randi()%max_card_rate_point
		for key in card_infos:
			var item =card_infos[key] 
			if item["range"][0]<=rand_i and item["range"][1]>=rand_i:
				if not key in card_have:
					ret_cards.append(key)
					card_have[key]=1
				break
		if ret_cards.size()>=3:
			break
	return ret_cards

func load_card_infos():
	var f=File.new()
	var info_file=config_folder+"/cards.dat"
	var cul_rate_point=0
	if f.file_exists(info_file):
		f.open(info_file, File.READ)
		var line_text=f.get_line()
		var first_line=true
		while line_text!="":
			if first_line:
				first_line=false
				line_text=f.get_line()
				continue
			var splited_line=line_text.split(",")
			var id=splited_line[0]
			var name=splited_line[1]
			var rate=int(splited_line[2])
			card_infos[id]={"id":id,"name":name,"rate":rate,"range":[cul_rate_point,cul_rate_point+rate]}
			cul_rate_point=cul_rate_point+rate
			line_text=f.get_line()
	
	max_card_rate_point=cul_rate_point



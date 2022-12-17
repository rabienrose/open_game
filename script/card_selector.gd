extends VBoxContainer

export (Array, NodePath) var btns

var update_period=2000
var last_update_time=0
var world


func _ready():
	pass

func on_create(_world):
	world=_world

func _on_Item_button_up():
	Global.emit_signal("input_choose_card",0)

func _on_Item2_button_up():
	Global.emit_signal("input_choose_card",1)

func _on_Item3_button_up():
	Global.emit_signal("input_choose_card",2)

func update_ui():
	if world.me.card_option_list.size()>0:
		visible=true
		var card_list=world.me.card_option_list[0]
		var i=0
		for btn_path in btns:
			get_node(btn_path).title.text=Global.card_infos[card_list[i]]["name"]
			get_node(btn_path).effect.text=world.me.get_card_effect(Global.card_infos[card_list[i]]["id"])
			i=i+1
	else:
		visible=false

extends Control

var list_control:ItemList
var msg

func _ready():
    list_control=$"rank_list"
    msg=get_node("/root/game/world/msg_center")
    msg.connect("show_chara_info",self,"update_chara_info")

func update_chara_info(chara):
    list_control.clear()
    var chara_info="name: "+chara.name
    # list_control.add_item(chara_info, null, false)
    for attr in chara.attrs:
        chara_info=attr+": "+str(chara.attrs[attr].get_val())
        list_control.add_item(chara_info, null, false)


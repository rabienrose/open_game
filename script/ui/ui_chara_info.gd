extends Control

var list_control:ItemList

func _ready():
    list_control=$"rank_list"

func update_chara_info(chara):
    list_control.clear()
    var chara_info="Name: "+chara.name
    list_control.add_item(chara_info, null, false)
    chara_info="Hp: "+str(chara.hp)
    list_control.add_item(chara_info, null, false)
    chara_info="Kill: "+str(chara.kill_count)
    list_control.add_item(chara_info, null, false)
    chara_info="Atk: "+str(chara.atk)
    list_control.add_item(chara_info, null, false)
    chara_info="Atk Spd: "+str(chara.atk_spd)
    list_control.add_item(chara_info, null, false)
    chara_info="Range: "+str(chara.atk_range)
    list_control.add_item(chara_info, null, false)
    chara_info="Mov Spd: "+str(chara.speed)
    list_control.add_item(chara_info, null, false)

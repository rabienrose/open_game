extends Control

var list_control:ItemList
var world

func _ready():
    list_control=$"rank_list"

class MyCustomSorter:
    static func sort_ascending(a, b):
        if a.kill_count > b.kill_count:
            return true
        return false

func update_rank_info():
    var all_charas=world.spawn.charactor_root.get_children()
    all_charas.sort_custom(MyCustomSorter, "sort_ascending")
    var t_count=0
    list_control.clear()
    for chara in all_charas:
        var chara_info=str(chara.name)+"[kill:"+str(chara.kill_count)+"][atk:"+str(chara.atk)+"][hp:"+str(chara.hp)+"][atk_spd:"+str(chara.atk_spd)+"]"
        list_control.add_item(chara_info, null, false)
        t_count=t_count+1
        if t_count>10:
            break

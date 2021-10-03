extends Control

var list_control:ItemList
var world
var msg
var all_charas={}
var chara_mgr

func _ready():
    chara_mgr=get_node("/root/game/world/chara_mgr")
    msg=get_node("/root/game/world/msg_center")
    list_control=$"rank_list"
    msg.connect("chara_die", self, "on_chara_kill")
    update_rank_info()

func on_chara_kill(killer_name, kill_count, dead_name):
    if killer_name!="":
        all_charas[killer_name]=kill_count
    if dead_name in all_charas:
        all_charas.erase(dead_name)

class MyCustomSorter:
    static func sort_ascending(a, b):
        if a[1] > b[1]:
            return true
        return false

func update_rank_info():
    while true:
        yield(get_tree().create_timer(1.0), "timeout")
        var temp_array=[]
        for chara in all_charas:
            temp_array.append([chara, all_charas[chara]])
        temp_array.sort_custom(MyCustomSorter, "sort_ascending")
        var t_count=0
        list_control.clear()
        list_control.add_item(str(temp_array.size()), null, false)
        for item in temp_array:
            var chara_info=str(item[0])+":"+str(item[1])
            list_control.add_item(chara_info, null, false)
            t_count=t_count+1
            if t_count>=5:
                break

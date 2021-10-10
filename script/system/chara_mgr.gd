extends Node2D
var map

func _ready():
    pass # Replace with function body.

func on_create(map_):
    map=map_
    

func add_chara(chara, pos_m, player_name, is_player):
    var temp_tscn = load("res://prefab/chara/"+chara+".tscn")
    var chara_obj=temp_tscn.instance()
    chara_obj.on_create(chara, player_name, pos_m, is_player)
    add_child(chara_obj)
    return chara_obj

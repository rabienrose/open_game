extends Object

var map
var world
var type_class_table={}
func init(_world):
    type_class_table["mob"]=load("res://assets/prefab/mob.tscn")
    type_class_table["player"]=load("res://assets/prefab/player.tscn")
    world=_world
    map=world.map

func batch_spwan(num, type):
    var character_res=type_class_table[type]
    for i in range(num):
       var t_w_posi = map.get_rand_free_spot()
       var player_obj = character_res.instance()
       player_obj.position=t_w_posi
       player_obj.world=world
       world.node.add_child(player_obj)


func spawn_a_player(posi, type):
    var character_res=type_class_table[type]
    var player_obj = character_res.instance()
    player_obj.position=posi
    player_obj.world=world
    world.node.add_child(player_obj)

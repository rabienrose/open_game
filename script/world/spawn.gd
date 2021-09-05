extends Object

var map
var world
var type_class_table={}
var charactor_root
var names_list=[]
func init(_world):
    type_class_table["mob"]=load("res://assets/prefab/mob.tscn")
    type_class_table["player"]=load("res://assets/prefab/player.tscn")
    world=_world
    map=world.map
    charactor_root=Node2D.new()
    charactor_root.name="charactor_root"
    world.node.add_child(charactor_root)
    var file = File.new()
    file.open("res://assets/config/names.json", File.READ)
    var content = file.get_as_text()
    var re = JSON.parse(content)
    names_list=re.result

func batch_spwan(num, type):
    var character_res=type_class_table[type]
    for i in range(num):
       var t_w_posi = map.get_rand_free_spot()
       var player_obj = character_res.instance()
       player_obj.position=t_w_posi
       player_obj.world=world
       var i_rand = randi() % names_list.size()
       player_obj.name=names_list[i_rand]
       player_obj.get_node("name_board").text=names_list[i_rand]
       names_list.erase(names_list[i_rand])
       charactor_root.add_child(player_obj)


func spawn_a_player(posi, type):
    var character_res=type_class_table[type]
    var player_obj = character_res.instance()
    player_obj.position=posi
    player_obj.world=world
    charactor_root.add_child(player_obj)

extends Object

var map
var chara_mgr
var chara_name_list=[]
var player_name_list=[]
var cell_offset
var rng
    

func on_create(map_, chara_mgr_):
    rng = RandomNumberGenerator.new()
    rng.randomize()
    map=map_
    chara_mgr=chara_mgr_
    var file = File.new()
    file.open("res://config/names.json", File.READ)
    var content = file.get_as_text()
    
    var re = JSON.parse(content)
    player_name_list=re.result
    var dir = Directory.new()
    if dir.open("res://prefab/chara") == OK:
        dir.list_dir_begin()
        var file_name = "."
        var chara_count=0
        while file_name != "":
            file_name = dir.get_next()
            if not "chamo" in file_name:
                continue
            var bare_name=file_name.split(".")[0]
            chara_name_list.append(bare_name)
    var tile_size=map.get_tile_size()
    cell_offset=Vector2(tile_size/2,tile_size-5)

func batch_spwan(num):
    var free_rand_posi = map.get_rand_spot(num,true,true)
    for i in range(free_rand_posi.size()):
        var rand_chara_id=rng.randi() % chara_name_list.size()
        var chara_name=chara_name_list[rand_chara_id]
        var name=player_name_list[i]
        var pos_m=map.convert_c_to_m_pos(free_rand_posi[i])+cell_offset
        chara_mgr.add_chara(chara_name,pos_m,name, false)



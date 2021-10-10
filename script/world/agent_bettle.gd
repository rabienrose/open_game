extends Node2D

var map
var spawner
var cam
var chara_mgr
var gift_mgr
var posion_circle
var rng
var msg

func _ready():
    msg=get_node("msg_center")
    
    rng = RandomNumberGenerator.new()
    rng.randomize()
    map=get_node("map")
    var maze_gen = load("res://res/system/maze_gen.tres")
    maze_gen.on_create(map)
    maze_gen.make_maze()
    var map_size_m = Rect2(Vector2(0,0), Vector2(map.map_w,map.map_h)*map.get_tile_size())
    var view_size=get_viewport().size

    cam=get_node("cam")
    cam.on_create(map_size_m, view_size)

    chara_mgr=get_node("chara_mgr")
    chara_mgr.on_create(map)
    
    spawner=load("res://script/system/spawn.gd").new()
    spawner.on_create(map, chara_mgr)
    spawner.batch_spwan(100)

    gift_mgr=get_node("gift_mgr")
    posion_circle=get_node("posion_circle")
    posion_circle.init_by_map(map)

    var posi_c = map.get_rand_spot(1,false,true)[0]
    var tile_size=map.get_tile_size()
    var cell_offset=Vector2(tile_size/2,tile_size-5)
    var posi_m = map.convert_c_to_m_pos(posi_c)+cell_offset
    cam.jump_to(posi_m)
    chara_mgr.add_chara("chamo_0",posi_m,"chamo1", true)
    # chara_mgr.add_chara("chamo_1",Vector2(1600,1650),"chamo1")
    msg.connect("game_over", self, "on_game_over")

func on_game_over():
    print("game over")
    cam.allow_pan=true


    
    


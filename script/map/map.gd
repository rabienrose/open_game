extends Node2D

class_name map

var custom_tiles={}
var chara_tiles={}
var tileset
var tilemap
var tile_update_step=0
var free_tile_pos_list=[]
var free_tile_pos_dict={}
var block_tile_pos_list=[]
var block_tile_pos_dict={}
var is_free_tile_dirty=true
var navigation2d
var map_w
var map_h
var rng

func _ready():
    rng = RandomNumberGenerator.new()
    rng.randomize()
    tilemap=get_node("Navigation2D/TileMap")
    navigation2d=get_node("Navigation2D")
    tileset=tilemap.tile_set
    check_tile_chara_loop()

func check_tile_chara_loop():
    var t_count=0
    while true:
        check_chara_tile_ok()
        t_count=t_count+1
        yield(get_tree().create_timer(1.0), "timeout")

func check_pos_c_in_map(pos_c):
    if pos_c.x>=0 and pos_c.x<map_w and pos_c.y>=0 and pos_c.y<map_h:
        return true
    else:
        return false

func trunc_area(pos_c, r):
    var min_x=pos_c.x-r
    if min_x<0:
        min_x=0
    var min_y=pos_c.y-r
    if min_y<0:
        min_y=0
    var max_x=pos_c.x+r
    if max_x>=map_w:
        max_x=map_w-1
    var max_y=pos_c.y+r
    if max_y>=map_h:
        max_y=map_h-1
    return [min_x, min_y, max_x, max_y]

func append_tile_chara(out_list, x, y, self_c):
    var t_vec2=Vector2(x, y)
    if t_vec2 in chara_tiles:
        for chara in chara_tiles[t_vec2]:
            if chara!=self_c:
                out_list.append(chara)

func get_near_characters(pos_m, r, num, self_c):
    var pos_c = convert_m_to_c_pos(pos_m)
    var chara_in_area=[]
    for i in range(r+1):
        if i==0:
            append_tile_chara(chara_in_area, pos_c.x, pos_c.y, self_c)
        else:
            var y=pos_c.y-i
            for x in range(pos_c.x-i, pos_c.x+i+1):
                append_tile_chara(chara_in_area, x, y, self_c)
            y=pos_c.y+i
            for x in range(pos_c.x-i, pos_c.x+i+1):
                append_tile_chara(chara_in_area, x, y, self_c)
            var x=pos_c.x-i
            for yy in range(pos_c.y-i+1, pos_c.y+i):
                append_tile_chara(chara_in_area, x, yy, self_c)
            x=pos_c.x+i
            for yy in range(pos_c.y-i+1, pos_c.y+i):
                append_tile_chara(chara_in_area, x, yy, self_c)
        if chara_in_area.size()>=num:
            break
    return chara_in_area

func check_chara_tile_ok():
    var chara_dict={}
    var dup_chara_count=0
    for tile in chara_tiles:
        for chara in chara_tiles[tile]:
            if chara in chara_dict:
                dup_chara_count=dup_chara_count+1
            else:
                chara_dict[chara]=1
    if dup_chara_count>0:
        print("dup_chara_count: ",dup_chara_count)

func on_chara_move(chara, old_pos_m, cur_pos_m):
    var old_pos_c = convert_m_to_c_pos(old_pos_m)
    var cur_pos_c = convert_m_to_c_pos(cur_pos_m)
    if old_pos_c.x!=cur_pos_c.x or old_pos_c.y!=cur_pos_c.y:
        custom_tiles[old_pos_c].on_leave(chara)
        custom_tiles[cur_pos_c].on_enter(chara)
        if not cur_pos_c in chara_tiles:
            chara_tiles[cur_pos_c]={}
        chara_tiles[cur_pos_c][chara]=1
        chara_tiles[old_pos_c].erase(chara)
        if chara_tiles[old_pos_c].size()==0:
            chara_tiles.erase(old_pos_c)
        

func on_chara_create(chara, cur_pos_m):
    var cur_pos_c=convert_m_to_c_pos(cur_pos_m)
    custom_tiles[cur_pos_c].on_enter(chara)
    if not cur_pos_c in chara_tiles:
        chara_tiles[cur_pos_c]={}
    chara_tiles[cur_pos_c][chara]=1

func on_chara_remove(chara):
    for tile in chara_tiles:
        if chara in chara_tiles[tile]:
            chara_tiles[tile].erase(chara)
            break
    
func clear_map():
    custom_tiles={}
    tilemap.clear()
    is_free_tile_dirty=true

func set_cellv(pos_c, tile_name):
    var tile_res = load("res://res/tile/"+tile_name+".tres")
    custom_tiles[pos_c]=tile_res
    var tile_id=tile_res.tile_id
    tilemap.set_cellv(pos_c, tile_id)
    is_free_tile_dirty=true

func get_cell_res(pos_c):
    return custom_tiles[pos_c]

func check_block(pos_c):
    var cell_id = tilemap.get_cellv(pos_c) 
    var re = tileset.tile_get_navigation_polygon(cell_id)
    if re==null:
        return true
    else:
        return false
    
func get_tile_size():
    return tilemap.cell_size.x

func update_block_info():
    free_tile_pos_list=[]
    free_tile_pos_dict={}
    block_tile_pos_list=[]
    block_tile_pos_dict={}
    var all_tiles=tilemap.get_used_cells()
    for pos_c in all_tiles:
        if not check_block(pos_c):
            free_tile_pos_list.append(pos_c)
            free_tile_pos_dict[pos_c]=1
        else:
            block_tile_pos_list.append(pos_c)
            block_tile_pos_dict[pos_c]=1
    is_free_tile_dirty=false

func get_rand_spot(num, b_exclude, b_free):
    if is_free_tile_dirty:
        update_block_info()
    var re_list=[]
    var ori_list=free_tile_pos_list
    if num>=ori_list.size():
        return []
    if not b_free:
        ori_list=block_tile_pos_list
    if b_exclude:
        var copy_list=[]
        for item in ori_list:
            copy_list.append(item)
        for i in range(num):
            var rand_i=rng.randi() % copy_list.size()
            re_list.append(copy_list[rand_i])
            copy_list.erase(copy_list[rand_i])
    else:
        for i in range(num):
            var rand_i=rng.randi() % ori_list.size()
            re_list.append(ori_list[rand_i])
    
    return re_list

func cal_path(s_posi, e_posi):
    return navigation2d.get_simple_path(s_posi, e_posi, false)  

func convert_c_to_m_pos(pos_c):
    return pos_c*tilemap.cell_size.x

func check_ray(src_char, tar_char):
    var space_state = get_world_2d().direct_space_state
    var temp_offset=Vector2(0,-20)
    var src_posi=src_char.position+temp_offset
    var tar_posi=tar_char.position+temp_offset
    var result = space_state.intersect_ray(src_posi, tar_posi, [src_char], src_char.collision_layer, true, true)
    if result:
        if result.collider==tar_char:
            return true
    return false

func convert_m_to_c_pos(pos_c):
    return Vector2(floor(pos_c.x/tilemap.cell_size.x), floor(pos_c.y/tilemap.cell_size.x)) 

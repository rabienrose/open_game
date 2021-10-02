extends Node2D

var timer
var x_free_range=[]
var y_free_range=[]
var last_x_free_range=[]
var last_y_free_range=[]
var cur_lev=0
var map
var rng
export(Array, String) var tile_names
export(int) var circle_step=5

func _ready():
    rng = RandomNumberGenerator.new()
    rng.randomize()
    print("posion_circle")
    timer = Timer.new()
    timer.set_wait_time(circle_step)
    timer.connect("timeout",self,"_on_timer_timeout") 
    add_child(timer)
    timer.start()
    
func init_by_map(map_):
    map=map_
    var width = map.map_w
    var height = map.map_h
    x_free_range=[0,width]
    y_free_range=[0,height]
    last_x_free_range=[0,width]
    last_y_free_range=[0,height]

func shrink_free_area():
    var temp_h_x=(x_free_range[0]+x_free_range[1])/2
    var temp_h_y=(y_free_range[0]+y_free_range[1])/2
    var half_size_new=int((x_free_range[1]-x_free_range[0])/4)
    
    if half_size_new<3:
        return false
    var temp_h_x_r=[temp_h_x-half_size_new, temp_h_x+half_size_new]
    var temp_h_y_r=[temp_h_y-half_size_new, temp_h_y+half_size_new]
    var x_rand = rng.randi() % int(temp_h_x_r[1]-temp_h_x_r[0])+temp_h_x_r[0]
    var y_rand = rng.randi() % int(temp_h_y_r[1]-temp_h_y_r[0])+temp_h_y_r[0]
    var new_x_min=x_rand-half_size_new
    if new_x_min<x_free_range[0]:
        new_x_min=x_free_range[0]
    var new_x_max=x_rand+half_size_new
    if new_x_max>x_free_range[1]:
        new_x_max=x_free_range[1]
    var new_y_min=y_rand-half_size_new
    if new_y_min<y_free_range[0]:
        new_y_min=y_free_range[0]
    var new_y_max=y_rand+half_size_new
    if new_y_max>y_free_range[1]:
        new_y_max=y_free_range[1]
    last_x_free_range=x_free_range
    last_y_free_range=y_free_range
    x_free_range=[new_x_min, new_x_max]
    y_free_range=[new_y_min, new_y_max]
    return true

func get_rand_spot_in_safe():
    var temp_free_spot=[]
    for i in range(x_free_range[0]+1,x_free_range[1]):
        for j in range(y_free_range[0]+1,y_free_range[1]):
            if not map.check_block(Vector2(i,j)):
                temp_free_spot.append(Vector2(i,j))
    var rand_i=rng.randi() % temp_free_spot.size()
    return temp_free_spot[rand_i]

func _on_timer_timeout():
    if x_free_range[1]-x_free_range[0]<last_x_free_range[1]-last_x_free_range[0]:
        cur_lev=cur_lev+1
        for i in range(last_x_free_range[0],last_x_free_range[1]):
            for j in range(last_y_free_range[0],last_y_free_range[1]):
                if i>x_free_range[0] and i<x_free_range[1] and j>y_free_range[0] and j<y_free_range[1]:
                    continue
                if not map.check_block(Vector2(i,j)):
                    map.set_cellv(Vector2(i,j), tile_names[cur_lev-1])
        if cur_lev>=4:
            cur_lev=0
            var re = shrink_free_area()
            if re==false:
                timer.stop()
    else:
        cur_lev=cur_lev+4
        if cur_lev>=4:
            cur_lev=0
            shrink_free_area()

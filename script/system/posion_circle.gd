extends Node2D

var cell_offset2 = {Vector2(0, -2):0, Vector2(2, 0):0, 
				  Vector2(0, 2):0, Vector2(-2, 0):0}
				
var cell_offset1 = {Vector2(0, -1):0, Vector2(1, 0):0, 
				  Vector2(0, 1):0, Vector2(-1, 0):0,
				Vector2(1, 1):0, Vector2(-1, 1):0,
				Vector2(-1, -1):0, Vector2(1, -1):0}

var tile_size
var current = Vector2(5, 2)
var unvisited = []  # array of unvisited tiles
var stack = []
var free_cells=[]
var tileset: TileSet
var self_obj
var init_offset
var navigation2d
var tile_infos={}
var timer
var cur_circle=null
var x_free_range=[0,width]
var y_free_range=[0,height]
var last_x_free_range=[0,width]
var last_y_free_range=[0,height]
var cur_lev=0

export var map:NodePath

func _ready():
	map=get_node("Navigation2D")
	world=get_node(world_p)
	init_tile_info()
	randomize()
	tile_size = map.cell_size.x
	tileset=map.tile_set
	make_maze()
	init_offset=Vector2(tile_size/2,tile_size-5)
	navigation2d=$"Navigation2D"
	timer = Timer.new()
	timer.set_wait_time(5)
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.start()

func shrink_free_area():
	var temp_h_x=(x_free_range[0]+x_free_range[1])/2
	var temp_h_y=(y_free_range[0]+y_free_range[1])/2
	var half_size_new=int((x_free_range[1]-x_free_range[0])/4)
	if half_size_new<3:
		return
	var temp_h_x_r=[temp_h_x-half_size_new, temp_h_x+half_size_new]
	var temp_h_y_r=[temp_h_y-half_size_new, temp_h_y+half_size_new]
	var x_rand = randi() % (temp_h_x_r[1]-temp_h_x_r[0])+temp_h_x_r[0]
	var y_rand = randi() % (temp_h_y_r[1]-temp_h_y_r[0])+temp_h_y_r[0]
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
	x_free_range=[new_x_min, new_x_max]
	y_free_range=[new_y_min, new_y_max]
	print(x_free_range, y_free_range)

func _on_timer_timeout():
	if x_free_range[1]-x_free_range[0]<last_x_free_range[1]-last_x_free_range[0]:
		cur_lev=cur_lev+1
		for i in range(last_x_free_range[0],last_x_free_range[1]):
			for j in range(last_y_free_range[0],last_y_free_range[1]):
				if i>x_free_range[0] and  i<x_free_range[1] and j>y_free_range[0] and j<y_free_range[1]:
					continue
				tile_infos[Vector2(i,j)]=cur_lev
				var tileset_id = map.get_cell(i,j)
				var shape_count = tileset.tile_get_shapes(tileset_id).size()
				if shape_count==0:
					map.set_cellv(Vector2(i,j), cur_lev+2)
		if cur_lev<4:
			cur_lev=0
			shrink_free_area()
	else:
		cur_lev=cur_lev+1
		if cur_lev<4:
			cur_lev=0
			shrink_free_area()
	timer.start()
	

func init_tile_info():
	for i in range(width):
		for j in range(height):
			tile_infos[Vector2(i,j)]=0
	
func get_rand_fre_spot():
	for i in range(10):
		var x_rand = randi() % (x_free_range[1]-x_free_range[0])+x_free_range[0]
		var y_rand = randi() % (y_free_range[1]-y_free_range[0])+y_free_range[0]
		var tileset_id = map.get_cell(x_rand,y_rand)
		var shape_count = tileset.tile_get_shapes(tileset_id).size()
		if shape_count==0:
			var t_w_posi = map.map_to_world(Vector2(x_rand, y_rand))
			t_w_posi=t_w_posi+init_offset
			return t_w_posi
	return get_rand_spot()

func get_rand_spot():
	var one_spot = free_cells[randi() % free_cells.size()]
	var t_w_posi = map.map_to_world(one_spot)
	t_w_posi=t_w_posi+init_offset
	return t_w_posi

func cal_path(s_posi, e_posi):
	return navigation2d.get_simple_path(s_posi, e_posi, false)   


func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_offset2:
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func check_outbound(v):
	if v.x>=0 and v.x<width and v.y>=0 and v.y<height:
		return true
	else:
		return false

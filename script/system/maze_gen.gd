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
export var width:int
export var heigth:int

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

func visit_near(current, unvisited):
	unvisited.erase(current)
	for n in cell_offset1:
		var t_cell=current + n
		if t_cell in unvisited:
			map.set_cellv(t_cell, 3)
			unvisited.erase(t_cell)
	
func make_maze():
	map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
			map.set_cellv(Vector2(x, y), 2)
	visit_near(current, unvisited)
	while step_rand_maze():
		pass
	var t_count=0
	while t_count<500:
		var x_rand = randi() % width
		var y_rand = randi() % height
		var cell_id = map.get_cell(x_rand, y_rand) 
		var re = tileset.tile_get_navigation_polygon(cell_id)
		if re==null:
			t_count=t_count+1
			var t_cell_pos=Vector2(x_rand, y_rand)
			map.set_cellv(t_cell_pos, 2)
			free_cells.append(t_cell_pos)
#
func step_rand_maze():
	if unvisited.size()==0:
		return false
	
	var neighbors = check_neighbors(current, unvisited)
	if neighbors.size() > 0:
		free_cells.append(current)
		var next = neighbors[randi() % neighbors.size()]
		stack.append(current)
		visit_near(next, unvisited)
		var t_offset=(next-current)/2
		
		map.set_cellv(current+t_offset, 2)
		free_cells.append(current+t_offset)
		current = next
	elif stack:
		current = stack.pop_back()
	return true

func _on_Button_button_down():
	step_rand_maze()

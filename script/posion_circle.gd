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
	timer = Timer.new()
	timer.set_wait_time(circle_step)
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	
	
func init_by_map(map_):
	timer.start()
	cur_lev=0
	map=map_
	var width = map.map_w
	var height = map.map_h
	x_free_range=[0,width]
	y_free_range=[0,height]
	last_x_free_range=[0,width]
	last_y_free_range=[0,height]

func shrink_free_area():
	var shrink_step=10
	var shrink_x_rand = rng.randi() % (shrink_step)
	var shrink_y_rand = rng.randi() % (shrink_step)
	var new_x_min=x_free_range[0]+shrink_x_rand
	var new_x_max=x_free_range[1]-(shrink_step-shrink_x_rand)
	var new_y_min=y_free_range[0]+shrink_y_rand
	var new_y_max=y_free_range[1]-(shrink_step-shrink_y_rand)
	last_x_free_range=x_free_range
	last_y_free_range=y_free_range
	x_free_range=[new_x_min, new_x_max]
	y_free_range=[new_y_min, new_y_max]
	if x_free_range[1]-x_free_range[0]<shrink_step:
		return false
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

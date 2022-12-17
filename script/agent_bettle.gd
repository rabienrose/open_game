extends Node2D

export (NodePath) var cam_path
export (NodePath) var tilemap_path
export (NodePath) var units_path
export (NodePath) var bullets_path
export (NodePath) var rank_ui_path
export (NodePath) var minimap_path
export (NodePath) var card_selector_path

var cam
var units
var bullets
var tilemap
var tileset
var rank_ui
var card_selector

var current = Vector2(5, 2)
var unvisited = []  # array of unvisited tiles
var stack = []

var cell_offset2 = {Vector2(0, -2):0, Vector2(2, 0):0, 
				  Vector2(0, 2):0, Vector2(-2, 0):0}
				
var cell_offset1 = {Vector2(0, -1):0, Vector2(1, 0):0, 
				  Vector2(0, 1):0, Vector2(-1, 0):0,
				Vector2(1, 1):0, Vector2(-1, 1):0,
				Vector2(-1, -1):0, Vector2(1, -1):0}

var free_tile_pos_list=[]
var block_tile_pos_list=[]
var tile_table={}
var is_free_tile_dirty=true

var key_pressed=[]

var players={}

var input_period=200
var last_input_proc_time=0
var navi_map=null
var init_b=false
var me=null
var posion_circle_change_period=20
var last_posion_change_time=0
var curent_poision_level=0
var curent_sub_poision_level=0
var posion_dmg_period=1000
var last_poision_dmg_time=0
var poision_dmg_tick=0

func visit_near(current, unvisited):
	unvisited.erase(current)
	for n in cell_offset1:
		var t_cell=current + n
		if t_cell in unvisited:
			tilemap.set_cellv(t_cell, 1)
			unvisited.erase(t_cell)

func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_offset2:
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func make_maze():
	for x in range(Global.map_size):
		for y in range(Global.map_size):
			unvisited.append(Vector2(x, y))
			tilemap.set_cellv(Vector2(x, y), 0)
	visit_near(current, unvisited)
	while step_rand_maze():
		pass
	var rand_tile = get_rand_spot(500, true, false)
	for pos_c in rand_tile:
		tilemap.set_cellv(pos_c, 0)
	is_free_tile_dirty=true

func step_rand_maze():
	if unvisited.size()==0:
		return false
	var neighbors = check_neighbors(current, unvisited)
	if neighbors.size() > 0:
		var next = neighbors[Global.rng.randi() % neighbors.size()]
		stack.append(current)
		visit_near(next, unvisited)
		var t_offset=(next-current)/2
		tilemap.set_cellv(current+t_offset, 0)
		current = next
	elif stack:
		current = stack.pop_back()
	return true

func check_block(pos_c):
	var cell_id = tilemap.get_cellv(pos_c) 
	var re = tileset.tile_get_navigation_polygon(cell_id)
	if re==null:
		return true
	else:
		return false

func update_block_info():
	free_tile_pos_list=[]
	block_tile_pos_list=[]
	var all_tiles=tilemap.get_used_cells()
	for pos_c in all_tiles:
		if not check_block(pos_c):
			free_tile_pos_list.append(pos_c)
			tile_table[pos_c]=0
		else:
			block_tile_pos_list.append(pos_c)
			tile_table[pos_c]=1
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
			var rand_i=Global.rng.randi() % copy_list.size()
			re_list.append(copy_list[rand_i])
			copy_list.erase(copy_list[rand_i])
	else:
		for i in range(num):
			var rand_i=Global.rng.randi() % ori_list.size()
			re_list.append(ori_list[rand_i])
	
	return re_list

func convert_c_to_m_pos(pos_c):
	return pos_c*Global.tile_size

func add_chara(chara, pos_m, player_name, is_player):
	var temp_tscn = load("res://prefab/chara/"+chara+".tscn")
	var chara_obj=temp_tscn.instance()
	chara_obj.on_create(chara, player_name, pos_m, is_player, self)
	units.add_child(chara_obj)
	return chara_obj

func spawn_player():
	var posi_c = get_rand_spot(1,false,true)[0]
	var tile_size=Global.tile_size
	var cell_offset=Vector2(tile_size/2,tile_size-5)
	var posi_m = convert_c_to_m_pos(posi_c)+cell_offset
	cam.jump_to(posi_m)
	me = add_chara("chamo_0",posi_m,"chamo1", true)
	batch_spwan(100)

func _ready():
	card_selector=get_node(card_selector_path)
	card_selector.on_create(self)
	rank_ui=get_node(rank_ui_path)
	rank_ui.on_create(self)
	bullets=get_node(bullets_path)
	units=get_node(units_path)
	tilemap=get_node(tilemap_path)
	tileset=tilemap.tile_set
	make_maze()
	var map_size_m = Rect2(Vector2(0,0), Vector2(Global.map_size,Global.map_size)*Global.tile_size)
	var view_size=get_viewport().size
	cam=get_node(cam_path)
	cam.on_create(map_size_m, view_size)
	spawn_player()
	get_node(minimap_path).on_create(self)
	get_node(minimap_path).generate_map_img()
	

func check_has_key(key):
	var ind=-1
	var n=0
	for item in key_pressed:
		if item==key:
			ind=n
			break
		n=n+1
	return ind

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if check_has_key(event.scancode)==-1:
				key_pressed.append(event.scancode)
		else:
			var key_ind=check_has_key(event.scancode)
			if key_ind!=-1:
				key_pressed.remove(key_ind)

func find_nearest_units(unit):
	var min_dist=-1
	var min_unit=null
	for c in units.get_children():
		if c==unit:
			continue
		var dist = (c.position-unit.position).length_squared()
		if min_unit==null or min_dist>dist:
			min_dist=dist
			min_unit=c
	return [min_unit, sqrt(min_dist)]

func _physics_process(delta):
	if Global.check_unit_valid(me)==false:
		return
	if init_b==false:
		init_b=true
		navi_map=Navigation2DServer.get_maps()[0]
	var cur_time=OS.get_ticks_msec()
	if last_input_proc_time==0:
		last_input_proc_time=cur_time
	if cur_time-last_input_proc_time>input_period:
		last_input_proc_time=cur_time
		if key_pressed.size()>0:
			var input_dir=Vector2(0,0)
			for item in key_pressed:
				if item == KEY_A:
					input_dir=input_dir+Vector2(-1,0)
				elif item == KEY_D:
					input_dir=input_dir+Vector2(1,0)
				elif item == KEY_W:
					input_dir=input_dir+Vector2(0,-1)
				elif item == KEY_S:
					input_dir=input_dir+Vector2(0,1)
			if input_dir!=Vector2(0,0):
				me.input=input_dir
			else:
				me.input=null
		else:
			me.input=null
	if last_posion_change_time==0:
		last_posion_change_time=cur_time
	if cur_time-last_posion_change_time>posion_circle_change_period*1000:
		last_posion_change_time=cur_time
		curent_sub_poision_level=curent_sub_poision_level+1
		if curent_sub_poision_level==3:
			curent_sub_poision_level=0
			curent_poision_level=curent_poision_level+1
		if curent_poision_level>0 and curent_poision_level<=4:
			for i in range(Global.map_size):
				for j in range(Global.map_size):
					set_free_tile(Vector2(i,j), 4)
			var half_poision_range=Global.h_posion_lv[curent_poision_level-1]
			for i in range(-half_poision_range,half_poision_range):
				for j in range(-half_poision_range,half_poision_range):
					var c_pos=Vector2(i,j)+Vector2(int(Global.map_size/2), int(Global.map_size/2))
					set_free_tile(c_pos, curent_sub_poision_level+2)
			var safe_poision_range=Global.safe_area_lv[curent_poision_level-1]
			for i in range(-safe_poision_range,safe_poision_range):
				for j in range(-safe_poision_range,safe_poision_range):
					var c_pos=Vector2(i,j)+Vector2(int(Global.map_size/2), int(Global.map_size/2))
					set_free_tile(c_pos, 0)
			get_node(minimap_path).generate_map_img()
	if last_poision_dmg_time==0:
		last_poision_dmg_time=cur_time
	if cur_time-last_poision_dmg_time>posion_dmg_period:
		last_poision_dmg_time=cur_time
		if curent_poision_level!=0:
			poision_dmg_tick=poision_dmg_tick+1
			for c in units.get_children():
				if Global.check_unit_valid(c)==false:
					continue
				var c_pos= m_pos_2_c_pos(c.position)
				if tile_table[c_pos]==4 and poision_dmg_tick%1==0:
					c.apply_poision_damage()
				if tile_table[c_pos]==3 and poision_dmg_tick%2==0:
					c.apply_poision_damage()
				if tile_table[c_pos]==2 and poision_dmg_tick%5==0:
					c.apply_poision_damage()
		
		
func set_free_tile(c_pos, tile_type):
	if tile_table[c_pos]==1:
		return
	if tile_table[c_pos]==tile_type:
		return
	tile_table[c_pos]=tile_type
	tilemap.set_cellv(c_pos, Global.tile_cell_table[tile_type] )

func m_pos_2_c_pos(m_pos):
	return Vector2(floor(m_pos.x/Global.tile_size), floor(m_pos.y/Global.tile_size)) 

func on_game_retart():
	pass

func on_game_over():
	pass

func _on_restart_button_down():
	on_game_retart()

func check_ray(src_char, tar_char):
	var space_state = get_world_2d().direct_space_state
	var temp_offset=Vector2(0,-20)
	var src_posi=src_char.position+temp_offset
	var tar_posi=tar_char.position+temp_offset
	var result = space_state.intersect_ray(src_posi, tar_posi, [], tilemap.get_collision_layer(), true, false)
	if not "collider" in result:
		return true
	return false

func batch_spwan(num):
	var file = File.new()
	file.open("res://config/names.json", File.READ)
	var content = file.get_as_text()
	var re = JSON.parse(content)
	var player_name_list=re.result
	var chara_name_list=[]
	var dir = Directory.new()
	if dir.open("res://prefab/chara") == OK:
		dir.list_dir_begin()
		var file_name = "."
		while file_name != "":
				file_name = dir.get_next()
				if not "chamo" in file_name:
						continue
				var bare_name=file_name.split(".")[0]
				chara_name_list.append(bare_name)
	var free_rand_posi = get_rand_spot(num,true,true)
	var cell_offset=Vector2(Global.tile_size/2,Global.tile_size-5)
	for i in range(free_rand_posi.size()):
		var rand_chara_id=Global.rng.randi() % chara_name_list.size()
		var chara_name=chara_name_list[rand_chara_id]
		var name=player_name_list[i]
		var pos_m=convert_c_to_m_pos(free_rand_posi[i])+cell_offset
		add_chara(chara_name,pos_m,name, false)



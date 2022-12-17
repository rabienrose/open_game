extends KinematicBody2D

class_name character

export (Resource) var bullet_fab
export (NodePath) var fct_mgr_path

var chara_name

var img:AnimatedSprite
var hp_bar:TextureProgress
var bar_red 
var bar_green 
var bar_yellow
var body_col_shape

var world
var fct_mgr

var direction:Vector2
var dir_posi_table={}
var dir_anim_table={}
var path_points=[]
var path_node_cur=1
var cur_mov_dist=0

var walk_spd=100
var atk_range=4
var atk_spd=0.5
var atk=10
var max_hp=10
var hp=max_hp


var input=null

var is_player=false
var is_moving=false

var dead=false

var ai_period=200
var last_ai_time=0
var atk_tar=null
var kill_num=0

var ai_status="idle" #idle atk
var last_atk_time=0

var card_option_list=[]

func _ready():
	fct_mgr=get_node(fct_mgr_path)
	dir_posi_table["front"]=$"down_shot"
	dir_posi_table["back"]=$"up_shot"
	dir_posi_table["right"]=$"right_shot"
	dir_posi_table["left"]=$"left_shot"
	body_col_shape=$"col_body"
	img=$"image"
	hp_bar=$"hp_bar"
	hp_bar.visible=false
	bar_red = preload("res://binary/images/ui/barHorizontal_red.png")
	bar_green = preload("res://binary/images/ui/barHorizontal_green.png")
	bar_yellow = preload("res://binary/images/ui/barHorizontal_yellow.png")
	img.playing=false
	
func on_create(chara_name_,name_, pos_m, is_player_, _world):
	world=_world
	position=pos_m
	set_name(name_)
	chara_name=chara_name_
	is_player=is_player_

func _physics_process(delta):
	var cur_time=OS.get_ticks_msec()
	if path_points.size()>0:
		if img.playing==false:
			img.play()
		if path_node_cur>=path_points.size():
			path_points=[]
			path_node_cur=0
			img.stop()
		else:
			var distance = path_points[path_node_cur] - position
			set_direction("walk", distance.normalized())
			if distance.length() > 5:
				move(direction*walk_spd*delta)
			else:
				path_node_cur=path_node_cur+1
	if input!=null:
		var dir = input.normalized()
		set_direction("walk", dir)
		move(dir * walk_spd)
		world.cam.jump_to(position)
		if is_moving==false:
			img.play()
			is_moving=true
	else:
		if is_moving==true:
			img.stop()
			is_moving=false
	if atk_tar!=null:
		if Global.check_unit_valid(atk_tar) and check_atk_range_valid(atk_tar):
			if cur_time-last_atk_time>1.0/atk_spd*1000:
				last_atk_time=cur_time
				attack(atk_tar)
		else:
			stop_atk()
	if last_ai_time==0:
		last_ai_time=cur_time
	if cur_time-last_ai_time>ai_period:
		last_ai_time=cur_time
		if path_points.size()==0:
			if is_player==false:
				var pos_c = world.get_rand_spot(1,false, true)[0]
				var pos_m=world.convert_c_to_m_pos(pos_c)
				path_points = Navigation2DServer.map_get_path(world.navi_map,position, pos_m,true)
				path_node_cur=0
			find_tar()
	if is_player==false:
		if card_option_list.size()>0:
			var card_id=card_option_list[0][0]
			card_option_list.remove(0)
			apply_card(card_id)

func stop_idle():
	path_points=[]
	path_node_cur=0
	img.stop()

func check_atk_range_valid(tar):
	if (position-tar.position).length()>(atk_range-1)*Global.tile_size:
		return false
	else:
		return true

func stop_atk():
	atk_tar=null

func attack(tar):
	var new_bullet= bullet_fab.instance()
	var distance = tar.position - position
	var dir=distance.normalized()
	set_direction("stand",dir)
	var src_posi = get_fire_position()
	var rot=atan2(dir.y,dir.x)*180/3.1415926
	new_bullet.bullet_range=atk_range
	world.bullets.add_child(new_bullet)
	new_bullet.shot(self, src_posi, rot)

func find_tar():
	if atk_tar==null:
		var tar = world.find_nearest_units(self)
		if tar[0]!=null and tar[1]<=(atk_range-1)*Global.tile_size:
			atk_tar=tar[0]
			stop_idle()

func set_name(name_):
	name=name_
	get_node("name_board").text=name_

func move(d_posi):
	if is_player==false:
		position=position+d_posi
	else:
		move_and_slide(d_posi)
	z_index=position.y/10

func get_fire_position():
	var dir_s = get_direction()
	var posi = dir_posi_table[dir_s].global_position
	return posi

func set_direction(action,  dir):
	direction=dir
	var dir_s = get_direction()
	switch_anim(action, dir_s)

func switch_anim(action, dir_s):
	img.animation=action+"_"+dir_s	

func get_direction():
	var dir_s="front"
	var abs_x=abs(direction.x)
	var abs_y=abs(direction.y)
	if direction.y>0 and abs_y>=abs_x: #down
		dir_s="front"
	elif direction.y<0 and abs_y>=abs_x: #up
		dir_s="back"
	elif direction.x>0 and abs_y<abs_x: #right
		dir_s="right"
	elif direction.x<0 and abs_y<abs_x: #left
		dir_s="left"
	return dir_s

func apply_damage(attacker):
	var val=attacker.atk
	if Global.check_unit_valid(attacker)==false:
		return
	fct_mgr.show_value(str(val))
	hp=hp-val
	if hp<=0:
		on_dead(attacker)
		return
	update_hp()

func apply_poision_damage():
	fct_mgr.show_value(str(1))
	hp=hp-1
	if hp<=0:
		on_dead(null)
		return
	update_hp()

func add_hp(val):
	if hp+val>max_hp:
		hp=max_hp
	else:
		hp=hp+val
	update_hp()

func update_hp():
	hp_bar.texture_progress = bar_green
	if hp < max_hp * 0.7:
		hp_bar.texture_progress = bar_yellow
	if hp < max_hp * 0.35:
		hp_bar.texture_progress = bar_red
	hp_bar.value = hp
	if hp<max_hp:
		hp_bar.visible=true
	else:
		hp_bar.visible=false
	
func on_dead(attacker):
	dead=true
	queue_free()
	world.rank_ui.update_rank_info()
	if Global.check_unit_valid(attacker):
		attacker.kill_num=attacker.kill_num+1
		var cards=Global.rand_pick_cards()
		attacker.card_option_list.append(cards)
		if attacker.is_player==true and world.me==attacker:
			world.card_selector.update_ui()

func _on_col_body_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed:
		pass

func apply_card(card_id):
	if card_id=="hp_1":
		add_hp(1)
	elif card_id=="hp_all":
		add_hp(max_hp)

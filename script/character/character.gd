extends KinematicBody2D

class_name character

var chara_name
var chara_type="base"

var img:AnimatedSprite
var hp_bar:TextureProgress
var bar_red 
var bar_green 
var bar_yellow
var body_col_shape

var map
var world
var fct_mgr
var msg

var direction:Vector2
var dir_posi_table={}
var dir_anim_table={}
var path_points:PoolVector2Array=PoolVector2Array()
var path_node_cur=1
var slow_tick_time=0
var med_tick_time=0
var fast_tick_time=0
var time_cul=0
var cur_mov_dist=0
var last_report_pos_c=null
var slow_tick_list={}
var med_tick_list={}
var fast_tick_list={}
var active_action=null

var skills=[]
var actions={}
var attrs={}
var bufs={}

var is_player=false

var dead=false

export(Array, Resource) var attr_res
export(Array, Resource) var skill_res
export(Array, Resource) var action_res

func _ready():
    world=get_node("/root/game/world")
    map=world.get_node("map")
    msg=world.get_node("msg_center")
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
    fct_mgr=$"fct_mgr"
    for res in attr_res:
        var attr_new=res.duplicate()
        attrs[attr_new.c_name]=attr_new
        attr_new.on_create(world, self)
        if attr_new.tick_hz_mode=="slow":
            slow_tick_list[attr_new.c_name]=funcref(attr_new, "tick")
        if attr_new.tick_hz_mode=="med":
            med_tick_list[attr_new.c_name]=funcref(attr_new, "tick")
        if attr_new.tick_hz_mode=="fast":
            fast_tick_list[attr_new.c_name]=funcref(attr_new, "tick")
    for res in skill_res:
        var skill_new=res.duplicate()
        skill_new.on_create(world, self)
        skills.append(skill_new)
    for res in action_res:
        var action_new=res.duplicate()
        action_new.on_create(world, self)
        actions[action_new.c_name]=action_new
    map.on_chara_create(self, position)
    
    
func on_create(chara_name_,name_, pos_m, is_player_):
    position=pos_m
    set_name(name_)
    chara_name=chara_name_
    is_player=is_player_
    if is_player==false:
        get_node("player_control").queue_free()

func add_buf(buf_res):
    if buf_res.c_name in bufs:
        return
    var buf_new=buf_res.duplicate()
    bufs[buf_new.c_name]=buf_new
    buf_new.on_create(world, self)
    if buf_new.tick_hz_mode=="slow":
        slow_tick_list[buf_new.c_name]=funcref(buf_new, "tick")
    if buf_new.tick_hz_mode=="med":
        med_tick_list[buf_new.c_name]=funcref(buf_new, "tick")
    if buf_new.tick_hz_mode=="fast":
        fast_tick_list[buf_new.c_name]=funcref(buf_new, "tick")

func remove_buf(buf_name):
    if buf_name in bufs:
        var buf_res=bufs[buf_name]
        if buf_res.tick_hz_mode=="slow":
            slow_tick_list.erase(buf_res.c_name)
        if buf_res.tick_hz_mode=="med":
            med_tick_list.erase(buf_res.c_name)
        if buf_res.tick_hz_mode=="fast":
            fast_tick_list.erase(buf_res.c_name)
        bufs.erase(buf_name)

func add_skill():
    pass

func remove_skill():
    pass

func _physics_process(delta):
    time_cul=time_cul+delta
    if active_action!=null :
        active_action.do(delta)
    if time_cul-fast_tick_time>0.01:
        var d_time=time_cul-fast_tick_time
        fast_tick_time=time_cul
        for key in fast_tick_list:
            fast_tick_list[key].call_func(d_time)
    if time_cul-med_tick_time>0.1: 
        var d_time=time_cul-med_tick_time
        for key in med_tick_list:
            med_tick_list[key].call_func(d_time)
        med_tick_time=time_cul
        
    if time_cul-slow_tick_time>1:
        var d_time=time_cul-slow_tick_time
        if is_player==false:
            var max_score=-1
            var max_action=null
            for key in actions:
                var score = actions[key].cal_score()
                if max_score==-1 or score>max_score:
                    max_score=score
                    max_action=actions[key]
            if max_action!=active_action:
                if active_action!=null:
                    active_action.on_switch_action(active_action, max_action)
                max_action.on_switch_action(active_action, max_action)
                active_action=max_action
        for key in slow_tick_list:
            slow_tick_list[key].call_func(d_time)
        slow_tick_time=time_cul

func set_name(name_):
    name=name_
    get_node("name_board").text=name_

func move(d_posi):
    move_and_slide(d_posi)
    cur_mov_dist=cur_mov_dist+d_posi.length()
    if last_report_pos_c==null:
        last_report_pos_c=position
    if cur_mov_dist>20:
        cur_mov_dist=0
        map.on_chara_move(self, last_report_pos_c, position)
        last_report_pos_c=position
    z_index=position.y

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
    if direction.y>0 and abs_y>abs_x: #down
        dir_s="front"
    elif direction.y<0 and abs_y>abs_x: #up
        dir_s="back"
    elif direction.x>0 and abs_y<abs_x: #right
        dir_s="right"
    elif direction.x<0 and abs_y<abs_x: #left
        dir_s="left"
    return dir_s

func _on_col_body_input_event(viewport, event, shape_idx):
    if event is InputEventScreenTouch and event.pressed:
        msg.emit_signal("show_chara_info", self)  

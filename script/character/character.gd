extends Node2D

class_name character

var speed=50
var img:AnimatedSprite
var hp=50
var max_hp=100
var atk_range=100
var atk_step=0.5
var hp_bar:TextureProgress
var bar_red 
var bar_green 
var bar_yellow 
var direction:Vector2
var dir_posi_table={}
var dir_anim_table={}
var shape:CollisionShape2D
var world
var path_points:PoolVector2Array=PoolVector2Array()
var path_node_cur=1
var ai_status
var chara_type="base"
var ai_tick_time=0

func _ready():
    dir_posi_table["down"]=$"down_shot"
    dir_posi_table["up"]=$"up_shot"
    dir_posi_table["right"]=$"right_shot"
    dir_posi_table["left"]=$"left_shot"
    dir_anim_table["down"]="00"
    dir_anim_table["up"]="02"
    dir_anim_table["right"]="03"
    dir_anim_table["left"]="01"
    img=$"image"
    hp_bar=$"hp_bar"
    hp_bar.visible=false
    hp_bar.max_value=max_hp
    bar_red = preload("res://binary/images/barHorizontal_red.png")
    bar_green = preload("res://binary/images/barHorizontal_green.png")
    bar_yellow = preload("res://binary/images/barHorizontal_yellow.png")
    img.playing=false
    img.speed_scale=speed/45.0
    shape=$"CollisionShape2D"
    shape.add_to_group("self")
    ai_status=load("res://script/ai/ai_status_base.gd").new()
    ai_status.host=self
    ai_status.world=world 
    
func _physics_process(delta):
    ai_tick_time=ai_tick_time+delta
    if ai_tick_time>0.2:
        var new_ai = ai_status.tick(ai_tick_time)
        ai_tick_time=0
        if new_ai!=null:
            ai_status=new_ai
    if path_points.size()>0:
        if img.playing==false:
            img.play()
        if path_node_cur>=path_points.size():
            path_points=PoolVector2Array()
            img.stop()
        else:
            var distance = path_points[path_node_cur] - position
            set_direction(distance.normalized())
            if distance.length() > 5:
                move(direction*speed*delta)
            else:
                path_node_cur=path_node_cur+1

func is_dead():
    return hp<=0

func is_moving():
    return path_points.size()>0

func stop_move():
    path_points=PoolVector2Array()

func set_move_tar_posi(tar_posi):
    path_points = world.map.cal_path(position, tar_posi)
    path_node_cur=1

func move(d_posi):
    position=position+d_posi
    z_index=position.y
    
func _unhandled_input(event):
    ai_status._unhandled_input(event)

func set_direction(dir):
    direction=dir
    var dir_s = get_direction()
    switch_anim(dir_s)

func switch_anim(dir_s):
    var anima_app = dir_anim_table[dir_s]
    img.animation="00_00_"+anima_app    
    
func update_hp():
    hp_bar.texture_progress = bar_green
    if hp < hp_bar.max_value * 0.7:
        hp_bar.texture_progress = bar_yellow
    if hp < hp_bar.max_value * 0.35:
        hp_bar.texture_progress = bar_red
    hp_bar.value = hp
    if hp<max_hp:
        hp_bar.visible=true
    else:
        hp_bar.visible=false
       
func shot(tar_posi):
    var distance = tar_posi - position
    var dir=distance.normalized()
    set_direction(dir)
    var dir_s = get_direction()
    var posi = dir_posi_table[dir_s].global_position
    var rot=atan2(dir.y,dir.x)*180/3.1415926
    world.add_new_bullet(posi, rot)

func get_direction():
    var dir_s="down"
    var abs_x=abs(direction.x)
    var abs_y=abs(direction.y)
    if direction.y>0 and abs_y>abs_x: #down
        dir_s="down"
    elif direction.y<0 and abs_y>abs_x: #up
        dir_s="up"
    elif direction.x>0 and abs_y<abs_x: #right
        dir_s="right"
    elif direction.x<0 and abs_y<abs_x: #left
        dir_s="left"
    return dir_s


extends Node2D

class_name character

var navigation2d:Navigation2D
var path_points:PoolVector2Array=PoolVector2Array()
var speed=50
var path_node_cur=1
var b_drag_mode=false
var b_ai=true
var world_node
var img:AnimatedSprite
var atk_tar=null
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
var bullet_res=null
var shape:CollisionShape2D
var ai_status
var attck_ai_s
var world

func _ready():
    dir_posi_table["down"]=$"down_shot"
    dir_posi_table["up"]=$"up_shot"
    dir_posi_table["right"]=$"right_shot"
    dir_posi_table["left"]=$"left_shot"
    dir_anim_table["down"]="00"
    dir_anim_table["up"]="02"
    dir_anim_table["right"]="03"
    dir_anim_table["left"]="01"
    bullet_res=preload("res://assets/bullet.tscn")
    navigation2d=$"/root/Node2D/Navigation2D"
    world_node=$"/root/Node2D"
    world=world_node.world
    img=$"image"
    hp_bar=$"hp_bar"
    hp_bar.visible=false
    hp_bar.max_value=max_hp
    bar_red = preload("res://assets/barHorizontal_red.png")
    bar_green = preload("res://assets/barHorizontal_green.png")
    bar_yellow = preload("res://assets/barHorizontal_yellow.png")
    img.playing=false
    img.speed_scale=speed/45.0
    shape=$"CollisionShape2D"
    shape.add_to_group("self")
    attck_ai_s=load("res://script/ai/attack.gd")
    ai_status=attck_ai_s.new()
    ai_status.host=self
    ai_status.world=world
    
func _unhandled_input(event):
    if b_ai:
        return
    if event is InputEventScreenTouch:
        if event.pressed:
            b_drag_mode=false
        else:
            shot(Vector2(0,0))
            if b_drag_mode==false:
                path_points = navigation2d.get_simple_path(position, get_global_mouse_position(), false)
                path_node_cur=1
            b_drag_mode=false
    if event is InputEventScreenDrag:
        b_drag_mode=true      
    
func on_hp_change():
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

func shot(tar_pos):
    var b = bullet_res.instance()
    world_node.add_child(b)
    var dir_s = get_direction()
    b.position = dir_posi_table[dir_s].global_position
    if dir_s=="right":
        b.rotation_degrees=0
    if dir_s=="up":
        b.rotation_degrees=-90
    if dir_s=="left":
        b.rotation_degrees=-180
    if dir_s=="down":
        b.rotation_degrees=90

func delay_start_move():
    yield(get_tree().create_timer(1.0), "timeout")
      
func _physics_process(delta):
    ai_status.tick()
    if path_points.size()>0:
        if img.playing==false:
            img.play()
        if path_node_cur>=path_points.size():
            path_points=PoolVector2Array()
            img.stop()
            ai_status="idle"
            delay_start_move()
        else:
            var distance = path_points[path_node_cur] - position
            direction = distance.normalized()
            if distance.length() > 5:
                position=position+direction*speed*delta
                z_index=position.y
                var dir_s = get_direction()
                var anima_app = dir_anim_table[dir_s]
                img.animation="00_00_"+anima_app
    #            move_and_slide(direction*speed)
            else:
                path_node_cur=path_node_cur+1
            if not b_ai:
                update()
    else:
        if b_ai and ai_status=="walk":
            var t_w_posi = world_node.get_rand_free_spot()
            path_points = navigation2d.get_simple_path(position, t_w_posi, false)
            path_node_cur=1

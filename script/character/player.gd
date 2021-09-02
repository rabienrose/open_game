extends character

func _ready():
    pass
    
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
            

func _draw():
    if path_points.size() > 1:
        for i in range(path_node_cur, path_points.size()):
            var p= path_points[i]
            draw_circle(p - position, 2, Color(1, 0, 0))

extends ai_status_base

var b_drag_mode=false

func _unhandled_input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            b_drag_mode=false
        else:
            if b_drag_mode==false:
                host.set_move_tar_posi(host.get_global_mouse_position())
            b_drag_mode=false
    if event is InputEventScreenDrag:
        b_drag_mode=true   


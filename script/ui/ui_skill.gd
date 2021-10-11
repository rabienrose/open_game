extends Control

var msg
var _touch_index :int = -1

func _ready():
    msg=get_node("/root/game/world/msg_center")

func _is_inside_control_rect(global_position: Vector2, control: Control) -> bool:
    var x: bool = global_position.x > control.rect_global_position.x and global_position.x < control.rect_global_position.x + (control.rect_size.x * control.rect_scale.x)
    var y: bool = global_position.y > control.rect_global_position.y and global_position.y < control.rect_global_position.y + (control.rect_size.y * control.rect_scale.y)
    return x and y

func _touch_started(event: InputEventScreenTouch) -> bool:
    return event.pressed and _touch_index == -1

func _touch_ended(event: InputEventScreenTouch) -> bool:
    return not event.pressed and _touch_index == event.index

func _input(event):
    if not (event is InputEventScreenTouch or event is InputEventScreenDrag):
        return
    if event is InputEventScreenTouch:
        if _touch_started(event) and _is_inside_control_rect(event.position, self):
            
            msg.emit_signal("skill_down","skill_1") 
        elif _touch_ended(event):
            _touch_index = -1
    
    

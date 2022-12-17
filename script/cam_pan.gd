extends Camera2D
class_name cam_pan

var events = {}
var last_drag_distance = 0
var avai_area: Rect2
var viewport_size: Vector2
var half_w:float
var half_h:float
var msg
var allow_pan=false

func _ready():
    pass
    
func on_create(avai_area_, viewport_size_):
    avai_area=avai_area_
    viewport_size=viewport_size_
    half_w=viewport_size.x/2
    half_h=viewport_size.y/2
    position=Vector2(avai_area.position.x+avai_area.size.x/2, avai_area.position.y+avai_area.size.y/2)

func _unhandled_input(event):
    
    if allow_pan==false:
        return
    if event is InputEventScreenTouch:
        if event.pressed:
            events[event.index] = event
        else:
            events.erase(event.index)

    if event is InputEventScreenDrag:
        events[event.index] = event
        if events.size() == 1:
            var next_p=position-event.relative.rotated(rotation) * zoom.x
            if next_p.x<half_w+avai_area.position.x:
                next_p.x=half_w+avai_area.position.x
            if next_p.x>avai_area.end.x-half_w:
                next_p.x=avai_area.end.x-half_w
            if next_p.y<half_h+avai_area.position.y:
                next_p.y=half_h+avai_area.position.y
            if next_p.y>avai_area.end.y-half_h:
                next_p.y=avai_area.end.y-half_h
            position=next_p

func jump_to(pos_m):
    position=pos_m

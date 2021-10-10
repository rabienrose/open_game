extends Control

var msg

func _ready():
    msg=get_node("/root/game/world/msg_center")

func _on_skill1_button_down():
    msg.emit_signal("skill_down","skill_1") 

func _on_skill1_button_up():
    msg.emit_signal("skill_up","skill_1") 

func _unhandled_input(event):
    if event is InputEventKey:
        if event.scancode == KEY_A:
            if event.pressed:
                msg.emit_signal("skill_down","skill_1") 
            else:
                msg.emit_signal("skill_up","skill_1") 
    

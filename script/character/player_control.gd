extends Node2D

class_name player_control

var character
var msg
var map
var skill_down=false
var b_drag=false

func on_skill_down(skill_type):
    skill_down=true

func on_skill_up(skill_type):
    skill_down=false

func _unhandled_input(event):
    if event is InputEventScreenTouch:
        if skill_down==false:
            if event.pressed:
                b_drag=false
            else:
                if b_drag==false:
                    var target_pos = get_global_mouse_position()
                    character.actions["move_to"].set_tar_posi(target_pos)
                    character.active_action=character.actions["move_to"]
        else:
            if event.pressed:
                var target_pos = get_global_mouse_position()
                character.actions["fire_bullet"].set_atk_position(target_pos)
                character.active_action=character.actions["fire_bullet"]
            else:
                character.actions["fire_bullet"].set_atk_position(null)
                character.active_action=null
                

    if event is InputEventScreenDrag:
        b_drag=true
        if skill_down==true:
            var target_pos = get_global_mouse_position()
            character.actions["fire_bullet"].set_atk_position(target_pos)
            
func _ready():
    character=get_node("..")
    if character.is_player==false:
        return
    msg=get_node("/root/game/world/msg_center")
    map=get_node("/root/game/world/map")
    msg.connect("skill_down", self, "on_skill_down")
    msg.connect("skill_up", self, "on_skill_up")
    



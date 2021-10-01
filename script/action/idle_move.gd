extends action_base

class_name idle_move

var path_points
var move_action
   
func cal_tar_posi():
    return world.map.get_rand_spot(1, false, true)[0]

func on_create(world_, owner_):
    .on_create(world_, owner_)
    move_action=load("res://res/action/move_to.tres").duplicate(true)
    move_action.on_create(world_, owner_)

func do(delta):
    if move_action.is_moving()==false:
        var posi_c = cal_tar_posi()
        var tile_size=world.map.get_tile_size()
        var posi_m=world.map.convert_c_to_m_pos(posi_c)+Vector2(tile_size/2,tile_size/2)
        move_action.set_tar_posi(posi_m)
    move_action.do(delta)    
    
func cal_score():
    return 0

func on_switch_action(old_action, new_action):
    if old_action==self:
        move_action.stop_move()

extends Resource

class_name action_base

export var c_name=""

var owner
var world

func on_create(world_, owner_):
    owner=owner_
    world=world_

func do(delta):
    pass

func cal_score():
    return -1000

func on_switch_action(old_action, new_action):
    pass

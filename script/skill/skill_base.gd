extends Resource

class_name skill_base

var use_checker

export var c_name=""

var owner
var world
var tick_hz_mode="none"

func on_create(world_, owner_):
    owner=owner_
    world=world_

func tick(delta):
    pass

func can_use():
    return false

func can_use_progress():
    return 0

func use_skill():
    pass

func place_skill(pos_m):
    pass





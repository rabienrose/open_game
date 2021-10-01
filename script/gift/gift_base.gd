extends Resource

class_name gift_base

export var c_name=""
export var desc=""

var owner
var world

func on_create(world_, owner_):
    owner=owner_
    world=world_

func apply_gift(chara):
    pass




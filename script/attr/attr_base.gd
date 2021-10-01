extends Resource

class_name attr_base

export var c_name=""

var owner
var world
var tick_hz_mode="none"

func on_create(world_, owner_):
    owner=owner_
    world=world_

func tick(delta):
    pass


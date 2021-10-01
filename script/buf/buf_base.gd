extends Resource

class_name buf_base

export var duration=1

export var c_name=""

var owner
var world
var tick_hz_mode="none"
var cul_time=0

func on_create(world_, owner_):
    owner=owner_
    world=world_

func on_time_out():
    owner.remove_buf(c_name)

func tick(delta):
    cul_time=cul_time+delta
    if cul_time>=duration:
        on_time_out()



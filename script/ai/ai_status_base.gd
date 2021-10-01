extends Resource

class_name ai_status_base

var owner
var world

func on_create(world_, owner_):
    world=world_
    owner=owner_

func tick(delta):
    return null

func _unhandled_input(event):
    pass

func gen_new_status(ai_name):
    var ai=load("res://res/status/"+ai_name+".tres")
    ai.on_create(world, owner)
    return ai
   

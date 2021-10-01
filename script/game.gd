extends Node2D

export var first_world_p:NodePath

var cur_world

func _ready():
    cur_world = get_node(first_world_p)
    add_child(cur_world)
    

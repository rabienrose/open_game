extends Node2D

export var first_level_p:NodePath

var cur_level

func _ready():
	cur_level = get_node(first_level_p)
	add_child(cur_level)
	

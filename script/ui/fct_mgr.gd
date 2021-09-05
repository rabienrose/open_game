extends Node2D

var fct_fab = preload("res://assets/prefab/fct.tscn")

var travel = Vector2(0, -80)
var duration = 2
var spread = PI/4

func show_value(value, crit=false):
    var fct = fct_fab.instance()
    add_child(fct)
    fct.show_value(str(value), travel, duration, spread, crit)

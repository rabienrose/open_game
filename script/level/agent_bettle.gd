extends Node2D

var map
var spawner
var maze_gen
var lottery_mgr

func _ready():
	map=get_node("map")
	spawner=get_node("spawner")
	maze_gen=get_node("maze_gen")
	lottery_mgr=get_node("lottery_mgr")

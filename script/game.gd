extends Node2D

var world
func _ready():
    world = load("res://script/world/world.gd").new()
    world.node=self
    world.init()

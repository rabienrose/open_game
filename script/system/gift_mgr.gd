extends Node2D

var all_gifts=[]
var gift_res_folder="res://res/gift/"

var rng

func _ready():
    rng = RandomNumberGenerator.new()
    rng.randomize()
    print("gift_mgr")
    var files = []
    var dir = Directory.new()
    dir.open(gift_res_folder)
    dir.list_dir_begin()
    while true:
        var file = dir.get_next()
        if file == "":
            break
        if ".tres" in file:
            all_gifts.append(load(gift_res_folder+file).duplicate(true))
            
func get_rand_gift():
    var i_rand = rng.randi() % all_gifts.size()
    return all_gifts[i_rand]


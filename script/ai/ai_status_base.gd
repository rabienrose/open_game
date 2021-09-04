extends Object

class_name ai_status_base

var host
var world
var ai_res_table={}
func _init():
    ai_res_table["persuit"]=load("res://script/ai/persuit.gd")
    ai_res_table["attack"]=load("res://script/ai/attack.gd")
    ai_res_table["idle"]=load("res://script/ai/idle.gd")
    ai_res_table["control_move"]=load("res://script/ai/control_move.gd")

func tick(delta):
    return null

func _unhandled_input(event):
    pass

func gen_new_status(ai_name):
    var ai = ai_res_table[ai_name].new()
    ai.host=host
    ai.world=world
    return ai
   

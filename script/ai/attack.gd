extends ai_status_base

var atk_tar

func tick(delta):
   if host.hp<host.max_hp*0.5:
       var idle_s = load("res://script/ai/idle.gd").new()
       return idle_s

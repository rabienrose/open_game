extends ai_status_base

var tar_char
var shot_step=0

func tick(delta):
    var return_ai=null
    if not is_instance_valid(host):
        return return_ai
    if not is_instance_valid(tar_char):
        return_ai = gen_new_status("idle")
        return return_ai
    var dis = (tar_char.position-host.position).length()
    if dis<400:
        if dis < host.atk_range-20 and world.check_ray(host, tar_char):
            shot_step=shot_step+delta
            if shot_step>=1/host.atk_spd:
                shot_step=0
                host.shot(tar_char.position)
        else:
            return_ai = gen_new_status("persuit")
            return_ai.tar_chara=tar_char
    else:
        return_ai = gen_new_status("idle")
    return return_ai


    

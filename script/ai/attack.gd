extends ai_status_base

var tar_char
var shot_step=0

func tick(delta):
    var return_ai=null
    if not is_instance_valid(tar_char):
        return_ai = gen_new_status("idle")
        return return_ai
    var dis = (tar_char.position-host.position).length()
    if dis<200:
        if world.check_ray(host, tar_char):
            shot_step=shot_step+delta
            if shot_step>=1:
                shot_step=0
                host.shot(tar_char.position)
        else:
            return_ai = gen_new_status("persuit")
            return_ai.tar_char=tar_char
    return return_ai


    

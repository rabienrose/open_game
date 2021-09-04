extends ai_status_base

var tar_chara
var cal_path_step=0

func tick(delta):
    if not is_instance_valid(host):
        return null
    cal_path_step=cal_path_step+delta
    if not is_instance_valid(tar_chara):
        return gen_new_status("idle")
    if world.check_ray(host, tar_chara):
        host.stop_move()
        var return_ai = gen_new_status("attack")
        return_ai.tar_char=tar_chara
        return return_ai
    if cal_path_step>1:
        cal_path_step=0
        host.set_move_tar_posi(tar_chara.position)
    return null

            

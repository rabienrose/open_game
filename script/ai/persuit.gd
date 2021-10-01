extends ai_status_base

var tar_chara
var cal_path_step=0

func tick(delta):
    if not is_instance_valid(owner):
        return null
    if not is_instance_valid(tar_chara):
        return gen_new_status("idle")
    cal_path_step=cal_path_step+delta
    if cal_path_step>1:
        cal_path_step=0
        var dis = (tar_chara.position-owner.position).length()
        if dis>1000:
            return gen_new_status("idle")
        if dis < owner.atk_range-20 and world.check_ray(owner, tar_chara):
            owner.stop_move()
            var return_ai = gen_new_status("attack")
            return_ai.tar_char=tar_chara
            return return_ai
        owner.set_move_tar_posi(tar_chara.position)
    return null

            

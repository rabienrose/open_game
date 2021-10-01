extends idle_move

func cal_tar_posi():
    return world.posion_circle.get_rand_spot_in_safe()

func cal_score():
    var pos_c=world.map.convert_m_to_c_pos(owner.position)
    var tile_res = world.map.get_cell_res(pos_c)
    if "lava"==tile_res.c_name:
        return 80
    else:
        return 0

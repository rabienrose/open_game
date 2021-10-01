extends tile_base

class_name lava_tile

export(Resource) var hp_buf_res

func on_enter(chara):
    chara.add_buf(hp_buf_res)

func on_leave(chara):
    chara.remove_buf(hp_buf_res.c_name)

func update(charas):
    pass


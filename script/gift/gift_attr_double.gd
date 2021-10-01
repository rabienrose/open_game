extends gift_base

export(String) var attr_name

func apply_gift(chara):
    if attr_name in chara.attrs:
        chara.attrs[attr_name].set_val(chara.attrs[attr_name].get_val()*2)



extends gift_base

export(int) var val

func apply_gift(chara):
    if "hp" in chara.attrs:
        chara.attrs["hp"].add_hp(val)

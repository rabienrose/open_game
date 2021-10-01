extends buf_base


export var amount=0

func on_create(world_, owner_):
    .on_create(world_, owner_)
    tick_hz_mode="slow"

func tick(delta):
    .tick(delta)
    if "hp" in owner.attrs:
        if amount<0:
            owner.attrs["hp"].apply_damage(-amount, null)
        else:
            owner.attrs["hp"].add_hp(amount)

extends buf_base

export var attr_name=""
export var amount=0

func on_create(world_, owner_):
    .on_create(world_, owner_)
    tick_hz_mode="slow"

func tick(delta):
    .tick(delta)
    if attr_name in owner.attrs:
        owner.attrs[attr_name].set_val(owner.attrs[attr_name].get_val()+amount)

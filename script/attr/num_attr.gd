extends attr_base

class_name num_attr

export var val=0
export var max_val=0
export var min_val=0

func set_val(val_):
    if val_>=max_val:
        val=max_val
    elif val_<=min_val:
        val_=min_val
    else:
        val= val_
    on_val_change()

func get_val():
    return val

func on_create(world_, owner_):
    .on_create(world_, owner_)
    tick_hz_mode="none"

func on_val_change():
    pass

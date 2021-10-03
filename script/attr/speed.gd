extends num_attr


func on_create(world_, owner_):
    .on_create(world_, owner_)
    owner.img.speed_scale=val/60.0

func on_val_change():
    owner.img.speed_scale=val/60.0

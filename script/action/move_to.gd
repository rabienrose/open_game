extends action_base

var path_points
var path_node_cur
   
func on_create(world_, owner_):
    .on_create(world_, owner_)
    path_points=PoolVector2Array()
    
func is_moving():
    return path_points.size()>0

func stop_move():
    path_points=PoolVector2Array()

func do(delta):
    if path_points.size()>0:
        if owner.img.playing==false:
            owner.img.play()
        if path_node_cur>=path_points.size():
            path_points=PoolVector2Array()
            owner.img.stop()
        else:
            var distance = path_points[path_node_cur] - owner.position
            owner.set_direction("walk", distance.normalized())
            if distance.length() > 5:
                var speed=10
                if "speed" in owner.attrs:
                    speed=owner.attrs["speed"].get_val()
                owner.move(owner.direction*speed)
            else:
                path_node_cur=path_node_cur+1

func set_tar_posi(tar_posi):
    path_points = world.map.cal_path(owner.position, tar_posi)
    path_node_cur=1

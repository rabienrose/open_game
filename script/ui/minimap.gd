extends Viewport

var proxy_map=null

func _ready():
    pass # Replace with function body.

func update_map(master_map):
    if proxy_map!=null:
        proxy_map.queue_free()
    proxy_map = master_map.duplicate(DUPLICATE_USE_INSTANCING)
    proxy_map.render_target_update_mode=UPDATE_ONCE
    add_child(proxy_map)
    

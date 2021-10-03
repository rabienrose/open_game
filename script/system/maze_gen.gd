extends Resource

class_name maze_gen

export var width=50
export var height=50

var map
var current = Vector2(5, 2)
var unvisited = []  # array of unvisited tiles
var stack = []

var cell_offset2 = {Vector2(0, -2):0, Vector2(2, 0):0, 
                  Vector2(0, 2):0, Vector2(-2, 0):0}
                
var cell_offset1 = {Vector2(0, -1):0, Vector2(1, 0):0, 
                  Vector2(0, 1):0, Vector2(-1, 0):0,
                Vector2(1, 1):0, Vector2(-1, 1):0,
                Vector2(-1, -1):0, Vector2(1, -1):0}

var rng

func on_create(map_):
    rng = RandomNumberGenerator.new()
    rng.randomize()
    map=map_

func visit_near(current, unvisited):
    unvisited.erase(current)
    for n in cell_offset1:
        var t_cell=current + n
        if t_cell in unvisited:
            map.set_cellv(t_cell, "obstacle")
            unvisited.erase(t_cell)

func check_neighbors(cell, unvisited):
    # returns an array of cell's unvisited neighbors
    var list = []
    for n in cell_offset2:
        if cell + n in unvisited:
            list.append(cell + n)
    return list

func make_maze():
    map.clear_map()
    map.map_w=width
    map.map_h=height
    for x in range(width):
        for y in range(height):
            unvisited.append(Vector2(x, y))
            map.set_cellv(Vector2(x, y), "road")
    visit_near(current, unvisited)
    while step_rand_maze():
        pass
    var rand_tile = map.get_rand_spot(500, true, false)
    for pos_c in rand_tile:
        map.set_cellv(pos_c, "road")

func step_rand_maze():
    if unvisited.size()==0:
        return false
    
    var neighbors = check_neighbors(current, unvisited)
    if neighbors.size() > 0:
        var next = neighbors[rng.randi() % neighbors.size()]
        stack.append(current)
        visit_near(next, unvisited)
        var t_offset=(next-current)/2
        map.set_cellv(current+t_offset, "road")
        current = next
    elif stack:
        current = stack.pop_back()
    return true

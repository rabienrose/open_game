extends Node2D

class_name Maze

var cell_offset2 = {Vector2(0, -2):0, Vector2(2, 0):0, 
                  Vector2(0, 2):0, Vector2(-2, 0):0}
                
var cell_offset1 = {Vector2(0, -1):0, Vector2(1, 0):0, 
                  Vector2(0, 1):0, Vector2(-1, 0):0,
                Vector2(1, 1):0, Vector2(-1, 1):0,
                Vector2(-1, -1):0, Vector2(1, -1):0}

var tile_size = 64  # tile size (in pixels)
var width = 50  # width of map (in tiles)
var height = 50  # height of map (in tiles)
var current = Vector2(5, 2)
var unvisited = []  # array of unvisited tiles
var stack = []
var player_res:Resource
var player_obj:Node2D
var spawn_cont=50
var free_cells=[]
var init_offset=null
var tileset: TileSet
var self_obj
var world

# get a reference to the map for convenience
onready var Map:TileMap = $Navigation2D/TileMap
onready var cam = $cam_pan

func _ready():
    world=load("res://script/world/world.gd").new()
    player_res=preload("res://player.tscn")
    randomize()
    tile_size = Map.cell_size.x
    init_offset=Vector2(tile_size/2,tile_size-5)
    tileset=Map.tile_set
    make_maze()
#    for i in range(spawn_cont):
#        var t_w_posi = get_rand_free_spot()
#        player_obj = player_res.instance()
#        player_obj.position=t_w_posi
#        add_child(player_obj)
    self_obj = player_res.instance()
    self_obj.position=cam.position
    self_obj.b_ai=false
    add_child(self_obj)
    
    
func get_rand_free_spot():
    var one_spot = free_cells[randi() % free_cells.size()]
    var t_w_posi = Map.map_to_world(one_spot)
    t_w_posi=t_w_posi+init_offset
    return t_w_posi
    
func check_neighbors(cell, unvisited):
    # returns an array of cell's unvisited neighbors
    var list = []
    for n in cell_offset2:
        if cell + n in unvisited:
            list.append(cell + n)
    return list
    
func check_outbound(v):
    if v.x>=0 and v.x<width and v.y>=0 and v.y<height:
        return true
    else:
        return false

func visit_near(current, unvisited):
    unvisited.erase(current)
    for n in cell_offset1:
        var t_cell=current + n
        if t_cell in unvisited:
            Map.set_cellv(t_cell, 3)
            unvisited.erase(t_cell)
    
func make_maze():
    Map.clear()
    for x in range(width):
        for y in range(height):
            unvisited.append(Vector2(x, y))
            Map.set_cellv(Vector2(x, y), 2)
    visit_near(current, unvisited)
    while step_rand_maze():
        pass
    var t_count=0
    while t_count<100:
        var x_rand = randi() % width
        var y_rand = randi() % height
        var cell_id = Map.get_cell(x_rand, y_rand) 
        var re = tileset.tile_get_navigation_polygon(cell_id)
        if re==null:
            t_count=t_count+1
            var t_cell_pos=Vector2(x_rand, y_rand)
            Map.set_cellv(t_cell_pos, 2)
            free_cells.append(t_cell_pos)
#
func step_rand_maze():
    if unvisited.size()==0:
        return false
    
    var neighbors = check_neighbors(current, unvisited)
    if neighbors.size() > 0:
        free_cells.append(current)
        var next = neighbors[randi() % neighbors.size()]
        stack.append(current)
        visit_near(next, unvisited)
        var t_offset=(next-current)/2
        
        Map.set_cellv(current+t_offset, 2)
        free_cells.append(current+t_offset)
        current = next
    elif stack:
        current = stack.pop_back()
    return true

func _on_Button_button_down():
    step_rand_maze()

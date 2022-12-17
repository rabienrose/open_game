extends TextureRect

var world
var update_period=2000
var last_update_time=0
var img=null

var minimap_size=400
var map_cell_size=minimap_size/Global.map_size

func _ready():
	pass

func on_create(_world):
	world=_world

func generate_map_img():
	img=Image.new()
	img.create(minimap_size,minimap_size,false,Image.FORMAT_RGB8)
	img.lock()
	
	for i in range(Global.map_size):
		for j in range(Global.map_size):
			var tile_type=world.tile_table[Vector2(i,j)]
			var b_posi=Vector2(i*map_cell_size, j*map_cell_size)
			var b_size=Vector2(map_cell_size, map_cell_size)
			if tile_type==0:
				img.fill_rect(Rect2(b_posi, b_size), Color(1.0, 1.0, 1.0 ,1.0))
			elif tile_type==1:
				img.fill_rect(Rect2(b_posi, b_size), Color(0.0, 0.0, 0.0 ,1.0))
			elif tile_type==2:
				img.fill_rect(Rect2(b_posi, b_size), Color(1.0, 0.8, 0.8 ,1.0))	
			elif tile_type==3:
				img.fill_rect(Rect2(b_posi, b_size), Color(1.0, 0.6, 0.6 ,1.0))	
			elif tile_type==4:
				img.fill_rect(Rect2(b_posi, b_size), Color(1.0, 0.4, 0.4 ,1.0))	
	img.unlock()
	draw_units()

func draw_units():
	var tex=ImageTexture.new()
	var temp_img=Image.new()
	temp_img.copy_from(img)
	# temp_img.create_from_data(minimap_size,minimap_size,false,Image.FORMAT_RGB8, img.get_data())
	# temp_img.create_from_data(img)
	temp_img.lock()
	for c in world.units.get_children():
		var minimap_pos = c.position/Global.tile_size*map_cell_size
		if world.me!=c:
			temp_img.fill_rect(Rect2(minimap_pos, Vector2(4,4)), Color(0.0, 0.0, 1.0 ,1.0))	
		else:
			temp_img.fill_rect(Rect2(minimap_pos, Vector2(10,10)), Color(1.0, 0.0, 0.0 ,1.0))	
	temp_img.unlock()
	tex.create_from_image(temp_img)
	texture=tex

func _process(delta):
	var cur_time=OS.get_ticks_msec()
	if last_update_time==0:
		last_update_time=cur_time
	if cur_time-last_update_time>update_period:
		last_update_time=cur_time
		draw_units()


tool
extends Button

var path_png="res://binary/images/chara/"
var path_res="res://res/chara/"
var path_chara_base="res://prefab/chara/chamo_temp.tscn"
var path_chara="res://prefab/chara/"
var dir_names=["front","left","right","back"]
var sprite_w=32
var sprite_h=48

func add_frame(pos, anima_name, sheet, anim_sprite, index):
    var box_left=pos.x*sprite_w
    var box_top=pos.y*sprite_h
    var tex = AtlasTexture.new()
    tex.atlas=sheet
    tex.region=Rect2(box_left, box_top, sprite_w, sprite_h)
    anim_sprite.add_frame(anima_name,tex,index)

func _on_import_chara_down():
    var f_temp = File.new()
    f_temp.open(path_chara_base, File.READ)
    var temp_text = f_temp.get_as_text()
    f_temp.close()
    var dir = Directory.new()
    if dir.open(path_res) == OK:
        dir.list_dir_begin()
        var file_name = "."
        var chara_count=0
        while file_name != "":
            file_name = dir.get_next()
            if not "chamo" in file_name:
                continue
            var new_chara_text=temp_text
            var bare_name=file_name.split(".")[0]
            new_chara_text=new_chara_text.replace("chamo_0.tres",file_name)
            var f_out = File.new()
            f_out.open(path_chara+bare_name+".tscn", File.WRITE)
            f_out.store_string(new_chara_text)
            f_out.close()

func convert_tga(filename):
    var f= File.new()
    f.open(filename,1) 
    f.get_32()
    var img_w = f.get_16()
    var img_h = f.get_16()
    f.seek(0x18)
    var img=Image.new()
    img.create(img_w, img_h, false, 5)
    img.lock()
    for i in range(img_h):
        for j in range(img_w):
            var b= f.get_8()/255.0
            var g= f.get_8()/255.0
            var r= f.get_8()/255.0
            var a= f.get_8()/255.0
            img.set_pixel(j,i,Color(r,g,b,a))
    img.unlock()
    var bare_name=filename.split(".")[0].split("/")[-1]
    img.save_png(bare_name+".png")

func _on_parse_tga_button_down():
    var filename="/home/rabienrose/Documents/code/temp/skillicon"
    convert_tga(filename+"/SI_3029.TGA")

func _on_import_sprite_down():
    var dir = Directory.new()
    var sheet_names={}
    if dir.open(path_png) == OK:
        dir.list_dir_begin()
        var file_name = "."
        var chara_count=0
        while file_name != "":
            file_name = dir.get_next()
            if "import" in file_name:
                continue
            if not "png" in file_name:
                continue
            var texture = load(path_png+file_name)
            for i in range(0,2):
                for j in range(0,4):
                    var anim_sprite= SpriteFrames.new()
                    anim_sprite.remove_animation("default")
                    for k in range(0, 4):
                        var anima_name="walk_"+dir_names[k]
                        anim_sprite.add_animation(anima_name)
                        anim_sprite.set_animation_speed(anima_name, 5)
                        anim_sprite.set_animation_loop(anima_name, true)
                        add_frame(Vector2(j*3+0,i*4+k), anima_name, texture, anim_sprite, 0)
                        add_frame(Vector2(j*3+1,i*4+k), anima_name, texture, anim_sprite, 1)
                        add_frame(Vector2(j*3+2,i*4+k), anima_name, texture, anim_sprite, 2)
                        add_frame(Vector2(j*3+1,i*4+k), anima_name, texture, anim_sprite, 3)
                    for k in range(0, 4):
                        var anima_name="stand_"+dir_names[k]
                        anim_sprite.add_animation(anima_name)
                        anim_sprite.set_animation_speed(anima_name, 5)
                        anim_sprite.set_animation_loop(anima_name, true)
                        add_frame(Vector2(j*3+1,i*4+k), anima_name, texture, anim_sprite, 0)
                    var full_name="chamo_"+str(chara_count)
                    ResourceSaver.save("res://res/chara/"+full_name+".tres", anim_sprite)
                    chara_count=chara_count+1




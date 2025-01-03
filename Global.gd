extends Node
const mres="user://"
const paths=["Saves","Options"]
var fname=""
var fformat="SN"
var otstp=5
var sn=[]
enum powers{wall}
enum program_history_items{game,menu}
var program_history=[program_history_items.menu]

enum game_history_items{nill,menu,set,premap,map}
var game_history=[game_history_items.nill]

enum menu_history_items{main,sett,saves,Allert}
var menu_history=[menu_history_items.main]

func bac_his():
	if len(menu_history)>1:
		menu_history.remove(len(menu_history)-1)
func bac_his_g():
	if len(game_history)>1:
		game_history.remove(len(game_history)-1)
func get_hero():
	return get_tree().current_scene.get_node("players/pl")
func get_prjklt_win():
	return Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))
# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode=Node.PAUSE_MODE_PROCESS
	for e in paths:
		Gcreate_path(mres,e)
	pass # Replace with function body.
var file=File.new()
func open_file(res,path,type):
	file.open(res+path,type)
	return file
func close_file():
	file.close()
func angle(V:Vector2):
	return -atan2(-V.y,V.x)
func _sqrt(v:Vector2):
	return sqrt(v.x*v.x+v.y*v.y)
func move(ang):
	return Vector2(cos(deg2rad(ang)),sin(deg2rad(ang)))
var dir=Directory.new()
func Gcreate_path(res,path,excut="",incut=""):
	var ot=false
	for t in path:
		if t=="/":
			ot=true
			break
	dir.open(res)
	if ot==true:
		var r=path.split("/")
		var op=""
		if !(dir.dir_exists(res+path)):
			for e in r:
				if e==excut and incut!="":
					e=incut
				if !(dir.dir_exists(res+op+e+"/")):
					dir.make_dir(e+"/")
					op+=e+"/"
					dir.open(res+op)
				else:
					op+=e+"/"
					dir.open(res+op)
		return op
	else:
		dir.make_dir(path)
		return path
func Gdel_path(res,path,excut="",incut=""):
	pass

func jos(a,b):
	if b!=0:
		return b*round(a/b)
	else:return 0
	
func circ(a,m,b):
	if b!=0:
		return m+abs(a)-abs(b*round(a/b))
	else:return m
func i_search(a,i):
	var inte=0
	for k in a:
		if k==i:
			return inte
		inte+=1
	return -1
	
	
var can_save=true
func save_game():
	if can_save==true and fname!="":
		var save_game = File.new()
		#var sn = get_tree().get_nodes_in_group("SN")
		save_game.open(mres+paths[0]+"/"+fname+"."+fformat, File.WRITE)
		#var sg=save_nodes(self)
		self.emit_signal("changed",self)
		var nods=get_tree().get_nodes_in_group("SN")
		for nod in nods:
			nod.emit_signal("changed",nod)
		save_game.store_line(to_json({"sn":sn}))
		save_game.close()
func load_game():
	#for z in get_tree().current_scene.get_tree().get_nodes_in_group("palki"):
		#z.clean()
	if (dir.file_exists("user://"+paths[0]+"/"+fname+"."+fformat)) and fname!="":
		var save_game = File.new()
		#var sn = get_tree().get_nodes_in_group("SN")
		save_game.open("user://"+paths[0]+"/"+fname+"."+fformat, File.READ)
		if save_game.get_len()!=0:
			sn=parse_json(save_game.get_line())["sn"]
			for p in sn:
				if get_node(p["path"])!=null:
					var n=get_node(p["path"])
					n.loade(p)
		else:
			print("can't load save 4sd")
		save_game.close()
	else:
		print("can't load save 43")

func _upd_saves():
	if fname!="":
		for e in paths:
			Gcreate_path(mres,e)
func _process(delta):
	#print(fname)
	match program_history[len(program_history)-1]:
		program_history_items.menu:
			if get_tree().current_scene.filename!="res://menu.tscn":
				get_tree().change_scene("res://menu.tscn")
			var m=get_tree().current_scene
			var b=m.get_node("buttons")
			m.slt.text="save: "+fname
			match menu_history[len(menu_history)-1]:
				menu_history_items.main:
					b.get_node("cntn").visible=fname!=""
					b.visible=true
					m.bem.visible=false
					m.sett.visible=false
					m.svs.visible=false
				menu_history_items.sett:
					b.visible=false
					m.bem.visible=false
					m.sett.visible=true
					m.svs.visible=false
				menu_history_items.saves:
					b.visible=false
					m.bem.visible=false
					m.sett.visible=false
					m.svs.visible=true
		program_history_items.game:
			if get_tree().current_scene.filename!="res://world.tscn":
				get_tree().change_scene("res://world.tscn")
				yield(get_tree(),"idle_frame")
			var set=get_tree().current_scene.get_node("cl/all/menu/settings")
			var butts=get_tree().current_scene.get_node("cl/all/menu/buttons")
			var win=get_prjklt_win()
			if butts!=null:
				get_tree().current_scene.get_node("cl/all").rect_size=get_prjklt_win()
				if  butts.get_node("cnt").is_connected("button_down",self,"gm_strt")==false:
					butts.get_node("cnt").connect("button_down",self,"gm_strt")
				if  butts.get_node("stng").is_connected("button_down",self,"game_sett")==false:
					butts.get_node("stng").connect("button_down",self,"game_sett")
				for e in butts.get_children():
					e.rect_size=Vector2(win.x/8,win.y/15)
					e.rect_position=Vector2(otstp,(e.rect_size.y+otstp)*e.get_index()+otstp)*e.rect_scale+Vector2(0,win.y/(butts.get_child_count()-0.3))
			match game_history[len(game_history)-1]:
				
				game_history_items.nill:
					get_tree().paused=false
					if butts!=null:
						butts.visible=false
						set.visible=false
					if Input.is_action_just_pressed("ui_cancel"):
						game_history.append(game_history_items.menu)
				game_history_items.menu:
					get_tree().paused=true
					butts.visible=true
					set.visible=false
					if Input.is_action_just_pressed("ui_cancel"):bac_his_g()
					pass
				game_history_items.set:
					butts.visible=false
					set.visible=true
					if Input.is_action_just_pressed("ui_cancel"):bac_his_g()
func game_sett():
	game_history.append(game_history_items.set)
func gm_strt():bac_his_g()
func save_nodes(n):
	var che=false
	if n!=self:
		for nod in sn:
			#if nod.has("pathm") and nod["pathm"]==n.get_path():
			#	var aw=i_search(sn,nod)
			#	sn.remove(aw)
			#	var sav=n.call("save")
			#	sn.insert(aw,sav)
			#	che=true
			if nod["path"]==n.get_path() and che==false:
				var aw=i_search(sn,nod)
				sn.remove(aw)
				sn.insert(aw,n.call("save_from_self"))
				che=true
		if che==false:
			sn.append(n.call("save_from_self"))
	else:
		for nod in sn:
			if n["path"]==self.get_path():
				var aw=i_search(sn,nod)
				sn.remove(0)
				sn.insert(0,n.call("save_from_self"))
				che=true
		if che==false:
			sn.insert(0,n.call("save_from_self"))
func load_d(n):
	for nd in sn:
		#if nd.has("pathm")==false:
		if nd["path"]==n.get_path():
			n.call("load_to_self",nd)
		#else:
		#	if nd["path"]==n.get_path() and nd["path"]!=nd["pathm"]:
		#		n.queue_free()
		#	if get_node(nd["pathm"])==null and get_node(nd["path"])==null:
		#		if get_tree().current_scene.w.get_node(i_search_lvl(nd["ilvl"]))!=null and search_in_loaded_nods(nd)==false:
		#			var cube=load("res://matireals/objects/rect/rb.tscn").instance()
		#			cube.can_emit=false
		#			get_tree().current_scene.w.get_node(i_search_lvl(nd["ilvl"])).call_deferred("add_child",cube)
		#			cube.set_deferred("global_position",Vector2(nd["pos_x"],nd["pos_y"]))
		#			cube.set("rotation_degrees",nd["rot"])
		#			cube.set("m",nd["m"])
		#			cube.set("ch_path",nd["pathm"])
		#			cube.set("con_nod",nd["id"])
		#			cube.set("in_lvl",nd["ilvl"])
		#			cube.set_deferred("path",nd["path"])
		#			cube.set("treveled",nd["tr"])
		#			loaded_nods.append(cube)
		#	else:
		#		if nd["path"]==n.get_path():
		#			n.call("loade",nd)
func recursiveWalk(dirPath):
	
	var dir = openDir(dirPath)
			
	dir.list_dir_begin(true, true)
	var fileName = dir.get_next()

	while fileName != "":
		var filePath = dirPath + "/" + fileName
		
		if dir.current_is_dir():
			#print("Dir found decending " + filePath)
			recursiveWalk(filePath)
		else:pass
			#print("File Path: " + filePath)
			# Process file HERE
	  
		fileName = dir.get_next()
	#print("Directory walking done: " + dirPath)
	dir.list_dir_end()
func breadthFirstWalk(dirPath):
	#print("-----------------------------------------------------------")
	#print(dirPath + " is the ROOT directory")
	#print("-----------------------------------------------------------")
	
	var directories = [dirPath]

	while !directories.empty():
		
		var currentDirPath = directories.pop_front()
		var dir = openDir(currentDirPath)
		dir.list_dir_begin(true, true)
		var fileName = dir.get_next()
		while fileName != "":
			
			var filePath = currentDirPath + "/" + fileName
			
			if dir.current_is_dir():
				#print(filePath + " is a directory")
				directories.push_back(filePath)
			else:
				#print(filePath + " is a file")
				directories.append(filePath)
				# Process File HERE
		
			fileName = dir.get_next()
		dir.list_dir_end()
		#print("Done with directory : " + currentDirPath)
		#print(directories)
		return directories
func openDir(dirPath):
	
	var dir = Directory.new()
	if dir.open(dirPath) != OK:
		print("Error opening directory: "+ dirPath)
		assert(false)
		return null
		
	return dir

func search(text:String):
	#print(text)
	var i1=0
	var t=text
	t.erase(i1,6)
	for w1 in range(0,len(t)):
		if w1>=0 and w1<len(t) and t[w1]=="/":t.erase(0,w1+1)
		if w1<0:break
		#else: break
	var t1=text
	t1.erase(len(text)-len(t),len(t))
	var exito=t.split(".")
	exito.append(t1)
	exito.append(t1.split("/"))
	return exito































































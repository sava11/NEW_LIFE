extends Node
var taked_jupers=false
var mega_jump=false
var can_wall=false
var guns=[]
var taked_mgazins=[]
var activ_gun=null
var sn=[]
var dir=Directory.new()
var portals_ids=[]
var lvl=[]
var fname=""
var fformat="iobana"
var can_save=true
enum menu_history_items{MM,MG,MS,GM,Allert,RES,GAME,pretab,tab,SCh}#MM-Main_Menu, MS-Main_Settings, V-Video, a-Audio
var menu_history=[menu_history_items.MM]
var file=File.new()
func open_file(res,path,type):
	file.open(res+path,type)
	return file
func close_file():
	file.close()
func get_hero():
	return get_tree().current_scene.get_node("/root/map/players/main_player/player")
func get_prjklt_win():
	return Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))
func cr_lvl(s):
	var rt=breadthFirstWalk("res://matireals/levels")
	return load(rt[s])
static func sum(array):
	var sum = 0.0
	for element in array:
		 sum += element
	return sum
func centr(verts):
	var _x_l=[]
	var _y_l=[]
	for zx in verts:
		_x_l.append(zx[0])
		_y_l.append(zx[1])
	var _len=len(verts)
	var _x=sum(_x_l)/_len
	var _y=sum(_y_l)/_len
	return Vector2(_x,_y)
func centr_v(vect:PoolVector2Array):
	var _x_l=[]
	var _y_l=[]
	for v in vect:
		_x_l.append(v.x)
		_y_l.append(v.y)
	var _len=len(vect)
	var _x=sum(_x_l)/_len
	var _y=sum(_y_l)/_len
	return Vector2(_x,_y)
func angle(V:Vector2):
	return -atan2(-V.y,V.x)
func _sqrt(v:Vector2):
	return sqrt(v.x*v.x+v.y*v.y)
func move(ang):
	return Vector2(cos(deg2rad(ang)),sin(deg2rad(ang)))
func fabsV(v):
	return Vector2(sqrt(v.x*v.x),sqrt(v.y*v.y))
func smooth(from,to,fr):
	return (to-from)*fr
func get_grav(v,g,s):
	return v*g*s
signal save;
signal loade;
signal reload_map;
signal loado(n);
signal changed(n);
func _ready():
	connect("reload_map",get_tree().current_scene.get_node("world"),"relmp")
	connect("loade",self,"load_game")
	connect("save",self,"save_game")
	connect("changed",self,"save_nodes")
	connect("loado",self,"loade")
	#ProjectSettings.get("application/config/custom_user_dir_name")
	for e in paths:
		full_paths.append(Gcreate_path("user://",e))
	if (dir.file_exists("user://"+paths[1]+"/Options.opt")):
		get_tree().current_scene.get_node("cl/main_menu/settings").loado()
func _search(a,i):
	for k in a:
		if k==i: return k
	return -1
func Gcreate_path(res,path,excut=""):
	var ot=false
	for t in path:
		if t=="/":
			ot=true
			break
	if ot==true:
		var r=path.split("/")
		var op=""
		if !(dir.dir_exists(res+path)):
			dir.open(res)
			for e in r:
				if e=="$" and excut!="":
					e=excut
				if !(dir.dir_exists(res+op+e+"/")):
					dir.make_dir(e+"/")
					op+=e+"/"
					dir.open(op)
				else:
					op+=e+"/"
					dir.open(op)
		return op
	else:
		return path
func _remove_paths(dire,text):
	if (dir.dir_exists(dire+text)):
		dir.open(dire)
		dir.remove(text)
func in_area(p,point):
	var result = false;
	var size=len(p)
	var j = size - 1;
	for i  in range(0,size):
		if ( (p[i].y < point.y && p[j].y >= point.y or p[j].y < point.y && p[i].y >= point.y) and (p[i].x + (point.y - p[i].y) / (p[j].y - p[i].y) * (p[j].x - p[i].x) < point.x) ):
			result = !result;
		j = i;
	return result

func get_area(pol):
	var area=0
	for i in range(0, len(pol) -1):
		area+=pol[i].x*pol[i+1].y-pol[i+1].x*pol[i].y
	return abs(area)

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
func clean(text:String,s:String):
	var t=text.split(s)
	var t1=[]
	for e in t:
		if e!="":
			t1.append(e)
	return t1

func create_path(path):
	var r=path.split("/")
	var op=""
	if !(dir.dir_exists("res://"+path)):
		dir.open("res://")
		for e in r:
			if e=="$":
				e=fname
			if !(dir.dir_exists("res://"+op+e+"/")):
				dir.make_dir(e+"/")
				op+=e+"/"
				dir.open(op)
			else:
				op+=e+"/"
				dir.open(op)
		#print(op)
		full_paths.append(op)
		#dir.make_dir(path+"/")
const paths=["saves","Options",]
var full_paths=[]

var treveled=false
var load_lvl_port=[]
func port_set_data(nn):
	lvl=load_lvl_port
	for p in nn:
		if get_node(p["path"])!=null and p["path"]!=get_hero().get_path():
			var n=get_node(p["path"])
			n.call_deferred("loade",p)
func save():
	var pos=[]
	if get_tree().current_scene.get_node("cl/main_menu").sttat==menu_history_items.GAME or get_tree().current_scene.get_node("cl/main_menu").sttat==menu_history_items.GM:
		for e in get_tree().current_scene.get_node("world").get_children():
			pos.append([e.global_position.x,e.global_position.y])
	var save_dict = {
		"path":get_path(),
		"level" : lvl,
		"tr":treveled,
		"pvrld":load_lvl_port,
		"tj":taked_jupers,
		"cw":can_wall,
		"mj":mega_jump,
		"tgu":guns,
		"pid":portals_ids,
		"tkdm":taked_mgazins,
		"poses":pos,
		"sint":get_tree().current_scene.get_node("cl/main_menu/cell_choise_").savesint
	}
	return save_dict
func loade(n):
	get_hero().bb=null
	for ww in get_tree().current_scene.get_node("world").get_children():
		ww.free()
	lvl=n["level"]
	#var into=0
	treveled=n["tr"]
	for l in lvl:
		get_tree().current_scene.get_node("world").add_child(cr_lvl(l).instance())
		#lvl.global_position=Vector2(n["poses"][into][0],n["poses"][into][1])
		#into+=1
	taked_jupers=n["tj"]
	can_wall=n["cw"]
	mega_jump=n["mj"]
	guns=n["tgu"]
	taked_mgazins=n["tkdm"]
	load_lvl_port=n["pvrld"]
	if guns!=[]:
		for p in sn:
			if p.has("name"):
				for e in get_tree().get_nodes_in_group("guns"):
					if p["name"]==e.gun_name:
						e.queue_free()
				var t=load("res://matireals/objects/gun/gun.tscn").instance()
				t.mode=RigidBody2D.MODE_STATIC
				get_hero().get_node("guns").call("add_child",t)
				t.load_info(p)
				t.position=Vector2.ZERO
				t.remove_child(t.find_node("ar"))
				#if t.gun_name
				t.visible=false
	portals_ids=n["pid"]
	for pid in portals_ids:
		get_tree().current_scene.get_node("portals").get_child(pid).open=true
	get_tree().current_scene.get_node("cl/main_menu/cell_choise_").savesint=n["sint"]
# Called when the node enters the scene tree for the first time.


func _upd_saves():
	if fname!="":
		for e in paths:
			Gcreate_path("res://",e)
func find_saves(res,t):
	if dir.dir_exists(res+paths[0]+t):
		return res+paths[0]+t

func save_game():
	if can_save==true and fname!="":
		var save_game = File.new()
		#var sn = get_tree().get_nodes_in_group("SN")
		save_game.open("user://"+paths[0]+"/"+fname+"."+fformat, File.WRITE)
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
	loaded_nods=[]
func del_node(n):
	for nod in sn:
		if nod["path"]==n.get_path():
			var aw=i_search(sn,nod)
			sn.remove(aw)
			return aw
	return -1
func search_path_for_saves_node_func_only(l,a):
	var i=0
	for e in l:
		if e.has(a):
			return i
		i+=1
	return -1
func save_nodes(n):
	var che=false
	if n!=self:
		for nod in sn:
			if nod.has("pathm") and nod["pathm"]==n.get_path():
				var aw=i_search(sn,nod)
				sn.remove(aw)
				var sav=n.call("save")
				sn.insert(aw,sav)
				che=true
			elif nod["path"]==n.get_path() and che==false:
				var aw=i_search(sn,nod)
				sn.remove(aw)
				var sav=n.call("save")
				sn.insert(aw,sav)
				che=true
		if che==false:
			var sav=n.call("save")
			sn.append(sav)
	else:
		for nod in sn:
			if nod["path"]==self.get_path():
				var aw=sn.find(nod)
				sn.remove(0)
				var sav=n.call("save")
				sn.insert(0,sav)
				che=true
		if che==false:
			var sav=n.call("save")
			sn.insert(0,sav)
	#print(sn)

func has_obj_in_level(obj:String,lvl:String):
	if len(obj.split(lvl))>1:
		return true
	return false
func reparent(what : Node, where : Node):
	what.get_parent().remove_child(what)
	where.call_deferred("add_child",what)
func search_lvl():
	var curr_lvl=[]
	var rt=breadthFirstWalk("res://matireals/levels")
	for e1 in get_tree().current_scene.w.get_children():
		for e in rt:
			if e==e1.filename:
				curr_lvl.append(e1.get_path())
	return curr_lvl
func i_search_lvl(i):
	var curr_lvl=null
	var rt=breadthFirstWalk("res://matireals/levels")
	for e1 in get_tree().current_scene.w.get_children():
		if rt[i]==e1.filename:
			curr_lvl=e1.get_path()
	return curr_lvl

func get_lvl(obj):
	var rt=breadthFirstWalk("res://matireals/levels")
	var into=0
	for e in rt:
		if e==get_node(obj.get_path()).filename:
			return into
		into+=1
	return -1
var loaded_nods=[]
func search_in_loaded_nods(nod):
	for e in loaded_nods:
		if is_instance_valid(e) and e.ch_path==nod["pathm"]:
			return true
	return false
func load_d(n):
	for nd in sn:
		if nd.has("pathm")==false:
			if nd["path"]==n.get_path():
				n.call("loade",nd)
		else:
			if nd["path"]==n.get_path() and nd["path"]!=nd["pathm"]:
				n.queue_free()
			if get_node(nd["pathm"])==null and get_node(nd["path"])==null:
				if get_tree().current_scene.w.get_node(i_search_lvl(nd["ilvl"]))!=null and search_in_loaded_nods(nd)==false:
					var cube=load("res://matireals/objects/rect/rb.tscn").instance()
					cube.can_emit=false
					get_tree().current_scene.w.get_node(i_search_lvl(nd["ilvl"])).call_deferred("add_child",cube)
					cube.set_deferred("global_position",Vector2(nd["pos_x"],nd["pos_y"]))
					cube.set("rotation_degrees",nd["rot"])
					cube.set("m",nd["m"])
					cube.set("ch_path",nd["pathm"])
					cube.set("con_nod",nd["id"])
					cube.set("in_lvl",nd["ilvl"])
					cube.set_deferred("path",nd["path"])
					cube.set("treveled",nd["tr"])
					loaded_nods.append(cube)
			else:
				if nd["path"]==n.get_path():
					n.call("loade",nd)
				
func find_data(n):
	for nod in sn:
		if nod["path"]==n.get_path():
			return nod
func find_nod(n):
	return get_node(n.get_path())

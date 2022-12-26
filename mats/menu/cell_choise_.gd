extends Panel
const g=Global
var saves=[]
var savesn=[]

func _upd():
	if loc_name!="":
	#g.recursiveWalk(_Path)
		savesn=[]
		#var save_game = File.new()
		g.open_file(g.mres,Global.paths[0]+"/"+loc_name+"."+Global.fformat, File.WRITE)
		g.close_file()
		#var sn = get_tree().get_nodes_in_group("SN")
		saves=g.breadthFirstWalk(g.mres+g.paths[0])
		for s in saves:
			savesn.append(g.search(s)[0])
		var win=g.get_prjklt_win()
		for i1 in get_children():
			if i1 is Button and i1!=$cr_n_s:
				i1.queue_free()
		for i in savesn:
			var e=load("res://mats/menu/save_menu/button.tscn").instance()
			add_child(e)
			#e.get_node("asp").stream=preload("res://matireals/media/menu/frow 2.wav")
			e.get_node("del").rect_size=Vector2(win.x/40,win.y/20)
			e.rect_size=Vector2(win.x-win.x/40,win.y/20)
			e.rect_position=Vector2(-e.get_node("del").rect_size.x,e.rect_size.y*e.get_index())
			e.text=savesn[g.i_search(savesn,i)]
			e.name=e.text
			move_child(e,0)
		var b=get_node("cr_n_s")
		#b.get_node("asp").stream=preload("res://matireals/media/menu/frow 2.wav")
		b.rect_size=Vector2(win.x,win.y/20)
		b.rect_position.y=b.rect_size.y*b.get_index()
		move_child(b,0)
	$sys_buttons/vs.max_value=len(savesn)+1
	$sys_buttons/vs.value=len(savesn)+1
	
func _ready():
	#g.recursiveWalk(_Path)
	saves=g.breadthFirstWalk(g.mres+g.paths[0])
	for s in saves:
		savesn.append(g.search(s))
		#pass
		#save_game.
	var win=g.get_prjklt_win()
	for i in savesn:
		var e=load("res://mats/menu/save_menu/button.tscn").instance()
		add_child(e)
		#e.get_node("asp").stream=preload("res://matireals/media/menu/frow 2.wav")
		e.get_node("del").rect_size=Vector2(win.x/40,win.y/20)
		e.rect_size=Vector2(win.x-win.x/40,win.y/20)
		e.rect_position=Vector2(-e.get_node("del").rect_size.x,e.rect_size.y*e.get_index())
		e.text=savesn[g.i_search(savesn,i)][0]
		e.name=e.text
		move_child(e,0)
	var b=get_node("cr_n_s")
	#b.get_node("asp").stream=preload("res://matireals/media/menu/frow 2.wav")
	b.rect_size=Vector2(win.x,win.y/20)
	b.rect_position.y=b.rect_size.y*b.get_index()
	move_child(b,0)
	$sys_buttons/vs.max_value=len(savesn)+1
	$sys_buttons/vs.value=len(savesn)+1
var last_fname=""
func _process(delta):
	var win=g.get_prjklt_win()
	rect_size=win/2
	$sys_buttons.rect_size=rect_size
	$sys_buttons.rect_position=Vector2(0,0)
	$sys_buttons/sbp.rect_size=Vector2(rect_size.x,win.y/20)
	$sys_buttons/sbp.rect_position=Vector2(0,rect_size.y-$sys_buttons/sbp.rect_size.y)
	$sys_buttons/sbp2.rect_size=Vector2(rect_size.x,win.y/20)
	$sys_buttons/sbp2.rect_position=Vector2(0,-$sys_buttons/sbp2.rect_size.y)
	$sys_buttons/vs.rect_size=Vector2(rect_size.x/10,rect_size.y-$sys_buttons/sbp.rect_size.y-g.otstp)
	$sys_buttons/vs.rect_position=Vector2(rect_size.x-$sys_buttons/vs.rect_size.x,g.otstp)
	$sys_buttons/vs.max_value=len(savesn)+1
	var butt=Vector2(rect_size.x+g.otstp,rect_size.y/20+g.otstp)-Vector2(g.otstp,g.otstp)-Vector2($sys_buttons/vs.rect_size.x,0)
	var t=(rect_size.y)/butt.y
	rect_position=win/2-rect_size/2
	var begin=Vector2(2,-$sys_buttons/sbp2.rect_size.y)
	var end=Vector2(0,rect_size.y-$sys_buttons/sbp.rect_size.y)
	$sys_buttons/vs.editable=$sys_buttons/vs.max_value>t
	#print(int((rect_size.y-$sys_buttons/sbp.rect_size.y)/(win.y/20*scale.y)))
	for i in get_children():
		if i is Button:
			i.rect_size=butt
			i.rect_position=Vector2(g.otstp/2,(i.rect_size.y*(i.get_index())+2+2*(i.get_index()))+(len(savesn)-18.7)*((butt.y)+1)*($sys_buttons/vs.value/$sys_buttons/vs.max_value-1))
			if i!=$cr_n_s:
				i.get_node("del").rect_size=Vector2(win.x/20,win.y/40)
				i.get_node("del").rect_position.x=-i.get_node("del").rect_size.x-2
			
			if i.rect_position.y>end.y or i.rect_position.y<begin.y:
				i.visible=false
			else:i.visible=true
	for i in $sys_buttons.get_children(): 
		if i is Button:
			i.rect_size=Vector2(win.x/10,win.y/20)#-Vector2(4,4)
			i.rect_position=Vector2(win.x/2*(i.get_index()-2)*(1-i.rect_size.x/rect_size.x),rect_size.y-i.rect_size.y-g.otstp/2)
			var sc=i.rect_size.y/win.y*win.y/15/2
			i.rect_scale=Vector2(sc,sc)
func _input(event):
	if event is InputEventMouseButton and visible==true and $sys_buttons/vs.editable==true:
		if event.button_index==4:
			$sys_buttons/vs.value+=(50*12/$sys_buttons/vs.max_value)
		if event.button_index==5:
			$sys_buttons/vs.value-=(50*12/$sys_buttons/vs.max_value)


func change_save(n):
	g.fname=n.text

func _on_cell_choise__visibility_changed():
	if visible==true:
		last_fname=g.fname
	pass # Replace with function body.


func _on_OK_button_down():
	if g.fname!="":
		last_fname=g.fname
		loc_name=""
		get_parent().get_node("settings").save_data()
		#g._upd_saves()
		g.bac_his()
		g.program_history.append(g.program_history_items.game)
	pass # Replace with function body.


func _on_cancel_button_down():
	if last_fname!=g.fname:
		if savesn!=[]:
			var zs=[]
			for i in savesn :
				zs.append(savesn[g.i_search(savesn,i)][0])
			if Global.i_search(zs,last_fname)!=-1:
				g.fname=last_fname
		else:
			g.fname=""
		g.bac_his()
	else:
		g.bac_his()
	loc_name=""
	get_parent().get_node("settings").save_data()
	pass # Replace with function body.

var loc_name=""
var savesint=0

func _on_cr_n_s_button_down():
	var si=[0]
	for s in g.breadthFirstWalk(g.mres+g.paths[0]):
		print(int(g.search(s)[0]))
		si.append(int(g.search(s)[0]))
	print(si)
	if si!=[]:
		savesint=si.max()+1
	else:
		savesint=0
	#if Global.dir.file_exists(g.mres+g.paths[1]+"/Options.opt"):
		#savesint=0
	loc_name="game_save_"+str(savesint)
	_upd()
	get_parent().get_node("settings").save_data()
	#Global._upd_saves()
	pass # Replace with function body.

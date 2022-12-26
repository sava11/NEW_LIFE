extends Control
onready var asp=$asp
onready var pnl=$choice_menu
onready var igm=$in_game_menu
onready var emenu=$Emenu
onready var sett=$settings
#onready var mplayer=get_tree().current_scene.get_node("players/main_player/player")
var res_changed=false
var exited=false
var g=Global
signal back
var sttat=g.menu_history_items.MM
var last_stream=null
var st_aud_list_sound=[]
var can_open_map=true


func play_one(bs):
	asp.stream=bs
	asp.play()
	asp.bus="buttons"





func bac_his():
	#print(len(g.menu_history))
	if len(g.menu_history)>1:
		g.menu_history.remove(len(g.menu_history)-1)
func _ready():
	if g.breadthFirstWalk("user://"+g.paths[0])==[]:
		g.fname=""
	var dir=Directory.new()
	if g.fname!="" and (dir.file_exists("res://"+g.paths[0]+"/"+g.fname+"."+g.fformat)) and g.open_file(g.paths[0]+"/"+g.fname+"."+g.fformat,File.READ).get_len()!=0:
		$choice_menu/new_game.text="continue"
		g.close_file()
	else:
		$choice_menu/new_game.text="New game"
		g.close_file()
	#dir.queue_free()
	for e in range(0,AudioServer.get_bus_count()):
		st_aud_list_sound.append(AudioServer.get_bus_volume_db(e))
	connect("back",self,"bac_his")
	var w=ProjectSettings.get("display/window/size/width")
	var h=ProjectSettings.get("display/window/size/height")
	emenu.rect_size=Vector2(w/2,h/2)
	emenu.rect_position=Vector2(w/2,h/2)-emenu.rect_size/2
	sett.get_node("exit").connect("button_up",self,"to_Main_Manu")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("main_menu"), linear2db($settings/menu_sound.value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("buttons"), linear2db($settings/button_sound.value*2)+st_aud_list_sound[AudioServer.get_bus_index("buttons")])
	var b_count=pnl.get_child_count()
	var b_id=0
	for b in pnl.get_children():
		if b is Button:
			b.rect_position.y=b_id*(b.rect_size.y+25)+h/4
			b.rect_position.x=-b.rect_size.x/2+w/2
			var sp=b.get_child(0)
			var scl=w/sp.texture.get_size().x
			sp.scale=Vector2(scl,scl)
			sp.global_position=Vector2(w,b.rect_position.y+b.rect_size.y/2+pnl.rect_position.y)
			b_id+=1
	b_id=0
	b_count=igm.get_child_count()
	for b in igm.get_children():
		if b is Button:
			b.rect_position.y=b_id*(b.rect_size.y+25)+h/b_count
			b.rect_position.x=-b.rect_size.x/2+w/2
			var sp=b.get_child(0)
			var scl=w/sp.texture.get_size().x
			sp.scale=Vector2(scl,scl)
			sp.global_position=Vector2(w,b.rect_position.y+b.rect_size.y/2+pnl.rect_position.y)#-h/b_count)
			b_id+=1
	b_id=0
	b_count=0
	for b in emenu.get_children():
		if b is Button:
			b_count+=1
	var bwid=10
	for b in emenu.get_children():
		if b is Button and b.visible==true:
			b.rect_position.x=b_id*(b.rect_size.x+bwid)+emenu.rect_size.x/2-(b.rect_size.x+bwid/1.5)/2*b_count
			b.rect_position.y=-b.rect_size.y/2+emenu.rect_size.y/1.4
			var sp=b.get_child(0)
			if sp is Sprite:
				var scl=emenu.rect_size.x/sp.texture.get_size().x
				sp.scale=Vector2(scl,scl)
				sp.global_position=Vector2(emenu.rect_size.x,b.rect_position.y+b.rect_size.y/2+emenu.rect_position.y)
			b_id+=1
	
func change_m():
	var w=ProjectSettings.get("display/window/size/width")
	var h=ProjectSettings.get("display/window/size/height")
	emenu.rect_size=Vector2(w/2,h/2)
	emenu.rect_position=Vector2(w/2,h/2)-emenu.rect_size/2
	var b_count=pnl.get_child_count()
	var b_id=0
	for b in pnl.get_children():
		if b is Button:
			b.rect_position.y=b_id*(b.rect_size.y+25)+h/4
			b.rect_position.x=-b.rect_size.x/2+w/2
			var sp=b.get_child(0)
			var scl=w/sp.texture.get_size().x
			sp.scale=Vector2(scl,scl)
			sp.global_position=Vector2(w,b.rect_position.y+b.rect_size.y/2+pnl.rect_position.y)
			b_id+=1
	b_id=0
	b_count=igm.get_child_count()
	for b in igm.get_children():
		if b is Button:
			b.rect_position.y=b_id*(b.rect_size.y+25)+h/b_count
			b.rect_position.x=-b.rect_size.x/2+w/2
			var sp=b.get_child(0)
			var scl=w/sp.texture.get_size().x
			sp.scale=Vector2(scl,scl)
			sp.global_position=Vector2(w,b.rect_position.y+b.rect_size.y/2+pnl.rect_position.y)#-h/b_count)
			b_id+=1
	b_id=0
	b_count=0
	for b in emenu.get_children():
		if b is Button:
			b_count+=1
	var bwid=10
	for b in emenu.get_children():
		if b is Button and b.visible==true:
			b.rect_position.x=b_id*(b.rect_size.x+bwid)+emenu.rect_size.x/2-(b.rect_size.x+bwid/1.5)/2*b_count
			b.rect_position.y=-b.rect_size.y/2+emenu.rect_size.y/1.4
			var sp=b.get_child(0)
			if sp is Sprite:
				var scl=emenu.rect_size.x/sp.texture.get_size().x
				sp.scale=Vector2(scl,scl)
				sp.global_position=Vector2(emenu.rect_size.x,b.rect_position.y+b.rect_size.y/2+emenu.rect_position.y)
			b_id+=1
onready var portals=get_parent().get_parent().get_node("portals")
onready var world=get_parent().get_parent().get_node("world")
onready var cam=get_parent().get_node("Control/ViewportContainer/Viewport/map/cam")
onready var vi=get_parent().get_node("Control/ViewportContainer/Viewport")
onready var her=get_parent().get_node("Control/ViewportContainer/Viewport/map/her")
onready var cont=get_parent().get_node("Control/ViewportContainer")
var event_pos=Vector2(0,0)
func _input(event: InputEvent) -> void:
	var w=g.get_prjklt_win().x
	var h=g.get_prjklt_win().y
	if event is InputEventScreenDrag:
		event_pos=event.position
	if event is InputEventMouseButton:
		if sttat==g.menu_history_items.tab:
			
			if event.button_index==4:
				cam.zoom*=0.9
			if event.button_index==5:
				cam.zoom=cam.zoom/0.9
			if cam.zoom.x<0.1:
				cam.zoom=Vector2(0.1,0.1)
			if cam.zoom.x>3:
				cam.zoom=Vector2(3,3)
func close_tab():
	cont.hide()
	#cam.get_node("S").hide()
	vi.size=get_viewport().size
	bac_his()
	get_tree().paused = false
	#get_tree().current_scene.get_node("cam").current=true
	cam.current=false
var v=Vector2.ZERO
var t=0
var dir=Directory.new()
func _process(delta):
	#print(dir.file_exists("res://"+g.filepath+"/"+g.fname+"."+g.fformat))
	if (dir.file_exists("user://"+g.paths[0]+"/"+g.fname+"."+g.fformat)) ==true and g.open_file("user://",g.paths[0]+"/"+g.fname+"."+g.fformat,File.READ).get_len()!=0:
		$choice_menu/new_game.text="continue"
		g.close_file()
	else:$choice_menu/new_game.text="New game";g.close_file() 
	$slot.text="using save: "+g.fname
	if sett.visible==false:
		sett.get_node("hbc/OptionButton").select(sett.wins.find([int(ProjectSettings.get("display/window/size/width")),int(ProjectSettings.get("display/window/size/height"))]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("main_menu"), linear2db($settings/menu_sound.value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("buttons"), linear2db($settings/button_sound.value*2)+st_aud_list_sound[AudioServer.get_bus_index("buttons")])
	if $Emenu/continue/asp.playing==false and exited==true:######################################################################################################
		get_tree().quit()
	sttat=g.menu_history[len(g.menu_history)-1]
	t+=delta
	if t>=0.1:
		#print(g.lvl," ",g.treveled)
		t=0
	#print(g.menu_history)
	match sttat:
		g.menu_history_items.SCh:
			pnl.hide()
			sett.hide()
			igm.hide()
			emenu.hide()
			$cell_choise_.show()
		g.menu_history_items.pretab:
			her.global_position=g.get_hero().global_position
			cam.position=her.position
			g.menu_history.pop_back()
			get_tree().paused = true
			g.menu_history.append(g.menu_history_items.tab)
			$cell_choise_.hide()
			#get_tree().current_scene.get_node("cam").current=false
			cam.current=true
			#sttat=g.menu_history[len(g.menu_history)-1]=g.menu_history_items.tab
		g.menu_history_items.tab:
			cont.show()
			vi.size=get_viewport().size
			#cam.get_node("S").position=cam.get_local_mouse_position()
			#her.global_position=g.get_hero().global_position
			#var ports=portals.get_children()
			cont.rect_size=OS.window_size
			var a=cont.get_local_mouse_position() - get_viewport().size * 0.5
			var s=get_viewport().size
			var s1=vi.size/s
			#cam.get_node("S").scale=cam.zoom
			her.global_position=g.get_hero().global_position
			her.global_rotation_degrees=g.get_hero().global_rotation_degrees
			if Input.is_action_just_pressed("lb"):
				v=cam.position-a*s1
			if Input.is_action_pressed("lb"):
				cam.position=(a*s1+v)
			var l=[]
			for g in portals.get_children():
				var gvx=(g.global_position-(cam.global_position))
				var za=sqrt(gvx[0]*gvx[0]+gvx[1]*gvx[1])
				l.append(za)
			var s2=(vi.size/s)
			var sq=sqrt(s2[0]*s2[0]+s2[1]*s2[1])
			for sa in l:
				if sa<=l.min() and sa<=100/sq:
					if Input.is_action_just_pressed("rb"):
						if portals.get_child(l.find(sa)).open==true:
							g.emit_signal("save")
							for oi in world.get_children():
								oi.free()
							var portal=portals.get_child(l.find(sa))
							g.get_hero().global_position=portal.global_position
							g.lvl=portal.lvls
							get_tree().paused = false
							g.get_hero().stop()
							for io in g.lvl:
								world.add_child(g.cr_lvl(io).instance())
							close_tab()
			if Input.is_action_just_pressed("tab"):
				close_tab()
		g.menu_history_items.MM:
			pnl.show()
			sett.hide()
			igm.hide()
			emenu.hide()
			$cell_choise_.hide()
			$aud.play=true
			get_tree().paused = true
			g.get_hero().visible=false
		g.menu_history_items.MS:
			pnl.hide()
			sett.show()
			igm.hide()
			emenu.hide()
			$cell_choise_.hide()
		g.menu_history_items.GM:
			pnl.hide()
			sett.hide()
			igm.show()
			emenu.hide()
			$cell_choise_.hide()
			get_tree().paused = true
		g.menu_history_items.Allert:
			pnl.hide()
			sett.hide()
			igm.hide()
			emenu.show()
			$cell_choise_.hide()
		g.menu_history_items.MG:
			pnl.hide()
			sett.hide()
			igm.hide()
			emenu.show()
			$cell_choise_.hide()
		g.menu_history_items.GAME:
			pnl.hide()
			sett.hide()
			igm.hide()
			emenu.hide()
			$cell_choise_.hide()
			$aud.play=false
			get_tree().paused = false
			close_tab()
			g.get_hero().visible=true
	#print(g.menu_history)
	if sttat==6 and Input.is_action_just_pressed("tab") and can_open_map:
		g.menu_history.append(g.menu_history_items.pretab)
	#print(g.menu_history)
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("back")
		if sttat==g.menu_history_items.GAME:
			play_one(preload("res://matireals/media/menu/frow 2.wav"))
			g.menu_history.append(g.menu_history_items.GM)
		if sttat==g.menu_history_items.MM:
			play_one(preload("res://matireals/media/menu/rgghr.wav"))
			g.menu_history.append(g.menu_history_items.MS)
		if sttat==g.menu_history_items.GM:
			play_one(preload("res://matireals/media/menu/frow 2.wav"))
			g.menu_history.append(g.menu_history_items.GAME)
		if sttat==g.menu_history_items.MS:
			play_one(preload("res://matireals/media/menu/rgghr.wav"))
			g.menu_history.append(g.menu_history_items.MM)

	#print(sttat)
func exit_to_menu():
	g.sn=[]
	g.lvl=[]
	#for world in get_tree().current_scene.get_node("world").get_children():
	#	world.queue_free()
	sttat=g.menu_history_items.MM
	g.menu_history=[g.menu_history_items.MM]
	for e in get_tree().current_scene.get_node("world").get_children():e.queue_free()
	emenu.get_node("continue").disconnect("button_up",self,"exit")
	emenu.get_node("continue").disconnect("button_up",self,"exit_to_menu")
	emenu.get_node("cws").disconnect("button_up",self,"exit")
	emenu.get_node("cws").disconnect("button_up",self,"exit_to_menu")
func back_any_exit():
	emenu.get_node("continue").disconnect("button_up",self,"exit")
	emenu.get_node("continue").disconnect("button_up",self,"exit_to_menu")
	emenu.get_node("cws").disconnect("button_up",self,"exit")
	emenu.get_node("cws").disconnect("button_up",self,"exit_to_menu")
	#igm.hide()
	bac_his()
func play():
	if $choice_menu/new_game.text=="continue":
		g.emit_signal("loade")
	else:
		if g.fname=="":
			g.fname="save0"
		g.emit_signal("reload_map")
	g.menu_history=[g.menu_history_items.GAME]
func back_to_game():
	g.menu_history=[g.menu_history_items.GAME]
func settings():
	g.menu_history.append(g.menu_history_items.MS)
func exit():
	exited=true
func to_Main_Manu():
	bac_his()

func _on_to_MM_button_up():
	emenu.get_node("continue").connect("button_up",self,"exit_to_menu")
	emenu.get_node("cws").connect("button_up",self,"exit_to_menu")
	emenu.get_node("cws").visible=true
	g.menu_history.append(g.menu_history_items.Allert)
	pass # Replace with function body.
func _on_EG_button_up():
	emenu.get_node("continue").connect("button_up",self,"exit")
	emenu.get_node("cws").connect("button_up",self,"exit")
	emenu.get_node("cws").visible=true
	g.menu_history.append(g.menu_history_items.Allert)
func _on_MG_button_up():
	emenu.get_node("continue").connect("button_up",self,"exit")
	emenu.get_node("cws").visible=false
	g.menu_history.append(g.menu_history_items.MG)


func _on_save_button_down():
	g.emit_signal("save")
	pass # Replace with function body.


func _on_load_button_down():
	if sttat!=6:
		g.menu_history=[g.menu_history_items.GAME]
	g.emit_signal("loade")
	pass # Replace with function body.


func _on_cell_choise_button_down():
	$cell_choise_._upd()
	g.menu_history.append(g.menu_history_items.SCh)
	get_tree().current_scene.get_node("cl/main_menu/cell_choise_")._upd()
	pass # Replace with function body.


func _on_main_massage(text):
	print(text)
	pass # Replace with function body.



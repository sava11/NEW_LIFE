extends Button
onready var asp=$asp
func _ready():
		connect("pressed_",get_parent(),"change_save")
signal pressed_(n);
func _on_button_down():
	emit_signal("pressed_",self)
	if asp.stream!=null:
		asp.play()


func _on_del_button_down():
	#g.recursiveWalk(_Path)
	
	#var sn = get_tree().get_nodes_in_group("SN")
	var dir =Directory.new()
	dir.remove(Global.mres+Global.paths[0]+"/"+text+"."+Global.fformat)
	print(Global.fname," ",text)
	if Global.fname==text:
		Global.fname=""#get_parent().last_fname
	if Global.breadthFirstWalk(Global.mres+Global.paths[0])==[]:
		Global.fname=""
	get_parent().savesn=[]
	for s in Global.breadthFirstWalk(Global.mres+Global.paths[0]):
		get_parent().savesn.append(Global.search(s)[0])
	#Global.emit_signal("changed")
	#Global._upd_saves()
	#Global._remove_paths("user://"+Global.paths[0],text)
	queue_free()
	#get_parent()._upd()
	pass # Replace with function body.

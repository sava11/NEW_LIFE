extends Node2D
export(String)var varible="open"
export(bool)var NOT=false
export(bool)var debug=false
var objs_to_open=[]
export(bool)var blocked=false
var open=false
var type=false
var g=Global
func save():
	var save_dict = {
		"path":get_path(),
		"open":open,
		"bled":blocked,
	}
	return save_dict
func loade(n):
	open=n["open"]
	blocked=n["bled"]
	get_parent().get_parent().open=open
signal changed(node)
signal loado(node)
func _ready():
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	emit_signal("loado",self)
func _process(delta):
	if debug==true:
		print(blocked," ",open," ",len(objs_to_open)," ",get_path())
	if blocked==true:
		var openl=0
		for n in objs_to_open:
			openl+=int(n.open)
		if openl<len(objs_to_open):
			open=false
			emit_signal("changed",self)
		elif openl==len(objs_to_open):
			open=true
			emit_signal("changed",self)
		if varible!="":
			if NOT==false:
				get_parent().get_parent().set(varible,open)
			else:
				get_parent().get_parent().set(varible,not(open))
#	if open==false and type==false:
#		emit_signal("changed",self)
#		type=true
#	if open==true and type==true:
#		emit_signal("changed",self)
#		type=false

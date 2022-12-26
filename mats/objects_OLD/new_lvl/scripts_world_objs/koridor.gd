extends Area2D
#export(PackedScene) onready var scene
var sts=Global
export(int) var scene=0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var sce
# Called when the node enters the scene tree for the first time.
func _ready():
	if name=="in":
		get_parent()._in=scene
	if name=="out":
		get_parent()._out=scene
	pass # Replace with function body.

func _a(body):
	if Global.i_search(get_parent().bs1,body)==-1:
		get_parent().bs1.append(body)
	if body!=Global.get_hero() or (body==Global.get_hero() and Global.treveled==false):
		if name=="in":
			var can_add=true
			for e in Global.lvl:
				if e==scene:
					can_add=false
			var t=null
			if can_add==true:
				t=sts.cr_lvl(scene).instance()
				get_tree().current_scene.get_node("world").call_deferred("add_child",t)
				#sce=t
				#sce.global_position=get_parent().pos
				sts.lvl.append(scene)
				for cho in t.get_children():
					if cho.name=="loads":
						for i in cho.get_children():
							for i1 in i.get_children():
								i1.set_deferred("monitoring",false)
								i1.set_deferred("monitorable",false)
								#i.emit_signal("changed",i)
				#
	if ((body!=Global.get_hero() and body.treveled==false) or body==Global.get_hero()):
		if name=="out":
			for cho in get_tree().current_scene.get_node("world").get_child(1).get_children():
				if cho.name=="loads":
					for i in cho.get_children():
						for i1 in i.get_children():
							i1.set_deferred("monitoring",true)
							i1.set_deferred("monitorable",true)
					#i.emit_signal("changed",i)
func find_pl():
	for e in get_parent().bs1:
		if e==Global.get_hero():
			return true
	return false



func _b(body):
	if body ==Global.get_hero() and Global.treveled==false:
		#print(Global.treveled)
		if Global.i_search_lvl(scene)!=null and get_node(Global.i_search_lvl(scene))!=null:
			sts.lvl.remove(sts.i_search(sts.lvl,scene))
			get_node(Global.i_search_lvl(scene)).queue_free()
		if Global.i_search(get_parent().bs1,body)!=-1:
			#print(g.i_search(bs1,b))
			get_parent().bs1.remove(Global.i_search(get_parent().bs1,body))
	pass # Replace with function body.

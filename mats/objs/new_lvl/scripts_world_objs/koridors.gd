extends Node2D
#export(Vector2)var pos
var _in=-1
var _out=-1
func save():
	var save_dict = {
		"path":get_path(),
		"inm":$in.get("monitoring"),
		"inmo":$in.get("monitorable"),
		"inm1":$out.get("monitoring"),
		"inmo1":$out.get("monitorable"),
		"am":$area.get("monitoring"),
		"amo":$area.get("monitorable"),
	}
	return save_dict
func loade(n):
	$in.set_deferred("monitoring",n["inm"])
	$in.set_deferred("monitoriable",n["inmo"])
	$out.set_deferred("monitoring",n["inm1"])
	$out.set_deferred("monitorable",n["inmo1"])
	$area.set_deferred("monitoring",n["am"])
	$area.set_deferred("monitorable",n["amo"])
signal changed(node)
signal loado(node)
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
var centr=Vector2.ZERO
onready var a=$area
func _ready():
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	centr=centr([$in.global_position,$out.global_position])
	var ft=$in.global_position-$out.global_position
	var ang=(180/PI)*-atan2(-ft.y,ft.x)
	var r=$area/CollisionShape2D.shape
	r.extents.x=sqrt(ft.x*ft.x+ft.y*ft.y)/2-10#get_tree().current_scene.treveled=true
	r.extents.y=sum([$in.get_node("c").shape.extents.y,$out.get_node("c").shape.extents.y])/2
	a.global_position=centr
	a.global_rotation_degrees=ang
	$in.global_rotation_degrees=ang
	$out.global_rotation_degrees=ang
	#$move_object.global_rotation_degrees=ang
	#emit_signal("loado",self)
const g=Global
func _process(delta):
	var ft=$out.global_position-$in.global_position
	var ang=(180/PI)*-atan2(-ft.y,ft.x)
	#print(bs1)
	for e in bs:
		if e!=null:
			var ts=e.global_position-$move_object.global_position
			var ang1=(180/PI)*-atan2(-ts.y,ts.x)
			if (ang-90<ang1 and ang+90>ang1):
				if get_node(g.i_search_lvl(_in))!=null and g.has_obj_in_level(e.get_path(),g.i_search_lvl(_in))==false:
					if g.i_search(bs,e)!=-1:
						bs.remove(g.i_search(bs,e))
					var pos=e.global_position
					var vel=e.get_linear_velocity()
					e.in_lvl=g.get_lvl(get_node(g.i_search_lvl(_in)))
					for nod in g.sn:
						if nod.has("pathm") and nod["path"]==e.path:
							var aw=g.i_search(g.sn,nod)
							g.sn.remove(aw)
							var sav=call("save")
							g.sn.insert(aw,sav)
					g.reparent(e,get_node(Global.i_search_lvl(_in)))
					e.global_position=pos
					e.set_deferred("global_position",pos)
					e.set_linear_velocity(vel)
					e.ch_path=str(Global.i_search_lvl(_in))+"/"+e.name
					print(e.ch_path)
					e.emit_signal("changed",e)
					g.save_nodes(e)
					if Global.treveled==false:
						get_node(g.i_search_lvl(_in)).queue_free()
						g.lvl.remove(g.i_search(g.lvl,_in))
			else:
				if get_node(Global.i_search_lvl(_out))!=null and g.has_obj_in_level(e.get_path(),Global.i_search_lvl(_out))==false:
					if g.i_search(bs,e)!=-1:
						bs.remove(g.i_search(bs,e))
					var pos=e.global_position
					var vel=e.get_linear_velocity()
					e.in_lvl=g.get_lvl(get_node(Global.i_search_lvl(_out)))
					for nod in g.sn:
						if nod.has("pathm") and nod["path"]==e.path:
							var aw=g.i_search(g.sn,nod)
							g.sn.remove(aw)
							var sav=call("save")
							g.sn.insert(aw,sav)
					g.reparent(e,get_node(Global.i_search_lvl(_out)))
					e.set_deferred("global_position",pos)
					e.set_linear_velocity(vel)
					e.ch_path=str(Global.i_search_lvl(_out))+"/"+e.name
					e.emit_signal("changed",e)
			#print(e.save())

var bs1=[]
func in_(b):
	if b.get_collision_layer_bit(1) and g.treveled==false:
		#emit_signal("changed",self)
		g.treveled=true
	elif b.get_collision_mask_bit(5) and b.treveled==false:
		b.treveled=true
func out(b):
	if b.get_collision_layer_bit(1) and g.treveled==true:
		g.treveled=false
	elif b.get_collision_mask_bit(5) and b.treveled==true:
		b.treveled=false

var bs=[]
func _on_move_object_body_entered(body):
	bs.append(body)
	pass # Replace with function body.


func _on_move_object_body_exited(body):
	if g.i_search(bs,body)!=-1:
		bs.remove(g.i_search(bs,body))
		
		
	pass # Replace with function body.

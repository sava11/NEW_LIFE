extends Node2D
export(float)var door_speed=100
#export(float)var door_way=125
export(float)var door_way=0
onready var d1=$c
onready var d2=$c2
export(bool)var open=false
export(float)var d1ang=0
export(float)var d2ang=0
export(bool)var blocked=false
func save():
	var save_dict = {
		"path":get_path(),
		"open":open,
		"bled":blocked,
		"d1pos":[d1.position.x,d1.position.y],
		"d2pos":[d2.position.x,d2.position.y]
	}
	return save_dict
func loade(n):
	open=n["open"]
	blocked=n["bled"]
	d1.position=Vector2(n["d1pos"][0],n["d1pos"][1])
	d2.position=Vector2(n["d2pos"][0],n["d2pos"][1])
signal changed(node)
signal loado(node)
func _ready():
	self.connect("changed",get_tree().current_scene,"save_nodes")
	self.connect("loado",get_tree().current_scene,"load_d")
	emit_signal("loado",self)
func _process(delta):
	d1.rotation_degrees=d1ang
	d2.rotation_degrees=d2ang
	if open==true:
		d1.position=d1.position.move_toward(Vector2(cos(deg2rad(d1ang-90)),sin(deg2rad(d1ang-90)))*door_way,door_speed*delta)
		d2.position=d2.position.move_toward(Vector2(cos(deg2rad(d2ang+90)),sin(deg2rad(d2ang+90)))*door_way,door_speed*delta)
	else:
		d1.position=d1.position.move_toward(Vector2.ZERO,door_speed*delta)
		d2.position=d2.position.move_toward(Vector2.ZERO,door_speed*delta)
	
var bl=[]
func _on_a_body_entered(b):
	if blocked==false and bl==[]:
		open=true
		emit_signal("changed",self)
	bl.append(b)

func _on_a_body_exited(b):
	bl.remove(bl.find(b))
	if blocked==false and bl==[]:
		open=false
		emit_signal("changed",self)


func _on_a2_body_entered(b):
	if b.is_in_group("block_items"):
		b.free()

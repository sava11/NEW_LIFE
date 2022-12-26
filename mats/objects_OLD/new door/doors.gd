extends Node2D
export(float)var door_speed=100
#export(float)var door_way=125
export(float)var door_way=0
onready var d1=$c
export(bool)var open=false
export(bool)var blocked=false
var g=Global
func save():
	var save_dict = {
		"path":get_path(),
		"open":open,
		"bled":blocked,
		"d1pos":[d1.position.x,d1.position.y],
	}
	return save_dict
func loade(n):
	open=n["open"]
	blocked=n["bled"]
	d1.position=Vector2(n["d1pos"][0],n["d1pos"][1])
signal changed(node)
signal loado(node)
var opening=false
func _ready():
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	emit_signal("loado",self)
	$c/hirtbox/col.polygon=$c.polygon
	var po=[]
	for e in $c/hirtbox/col.polygon:
		po.append(e*Vector2(0,1))
	$c/hirtbox/col.polygon=po
var pos=Vector2.ZERO
func _process(delta):
	var lp=Global._sqrt(d1.position)
	if open==true:
		d1.position=d1.position.move_toward(Vector2(cos(deg2rad(rotation_degrees-90)),sin(deg2rad(rotation_degrees-90)))*door_way,door_speed*delta)
		if int(lp)==int(abs(door_way)):
			opening=false
		else:opening=true
	else:
		d1.position=d1.position.move_toward(pos,door_speed*delta)
		
		if int(lp)==0:
			opening=false
		else:opening=true
	if opening==true:
		$c/aud.play=true
	else:
		$c/aud.play=false
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
func _on_a2_body_entered(b):pass
var in_=false
func _on_aa_body_entered(body):
	pos=d1.position
	in_=true
	pass # Replace with function body.


func _on_aa_body_exited(body):
	pos=Vector2.ZERO
	in_=true
	pass # Replace with function body.

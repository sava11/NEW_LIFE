extends Node2D
export(float,-180,180) var see_ang=0
onready var seen_angle=$t2.rotation_degrees
const g=Global
func save():
	var save_dict = {
		"path":get_path(),
		"t-r":$t.rotation_degrees,
		"t2-r":$t2.rotation_degrees,
	}
	return save_dict
func loade(n):
	$t.set_deferred("rotation_degrees",n["t-r"])
	$t2.set_deferred("rotation_degrees",n["t2-r"])
signal changed(node)
signal loado(node)
func _ready():
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	$t/c.polygon=$t/p.polygon
	$t2/c.polygon=$t2/p.polygon
func _process(delta):
	
	pass

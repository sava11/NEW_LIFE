extends RigidBody2D
export(int)var kalibr_id=0
var inn=null
var droped=false
var tked=false
func _ready():
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	emit_signal("loado",self)
	if droped==false:
		if tked==true:
			self.queue_free()
signal loado(node)
signal changed(node)
func save():
	var save_dict = {
		"path":get_path(),
		"tk":tked
	}
	return save_dict
func loade(n):
	tked=n["tk"]

func _physics_process(delta):
	if inn==Global.get_hero() and Input.is_action_just_pressed("e"):
		for e in inn.get_node("guns").get_children():
			if e.kalibr_id==kalibr_id:
				tked=true
				emit_signal("changed",self)
				e.magazin_value+=1
				e.call("upd_magzs")
				Global.taked_mgazins.append(self.get_path())
				self.queue_free()
			else:print("you don't have an gun that this ammo magazine would use")
func _on_a_body_entered(b):
	inn=b
func _on_a_body_exited(b):
	inn=null

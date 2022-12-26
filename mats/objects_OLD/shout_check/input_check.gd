extends Area2D
var open=false
export(Color)var acol
export(Color)var bcol
export(Color)var ERRcol
export(bool)var blocked=false
func _ready():
	self.connect("changed",get_tree().current_scene,"save_nodes")
	self.connect("loado",get_tree().current_scene,"load_d")
	emit_signal("loado",self)
	if $key_lock/key.active==true:
		if open==true:
			$p.color=acol
		else:
			$p.color=bcol
	else:$p.color=ERRcol
signal loado(node)
signal changed(node)
func save():
	print("save")
	var save_dict = {
		"path":get_path(),
		"open":open,
		"blck":blocked,
	}
	return save_dict
func loade(n):
	open=n["open"]
	blocked=n["blck"]
	
	pass # Replace with function body.

func _chk():
	if $key_lock/key.active==true and blocked==false:
		if open==false:
			open=true
			$p.color=acol
		else:
			open=false
			$p.color=bcol
	else:
		$p.color=ERRcol
		open=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_a_entered(b):
	if b.is_in_group("e_ammo"):
		_chk()
		emit_signal("changed",self)
		b.get_parent().queue_free()

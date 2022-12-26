extends Node2D
var body=null
var open=false
export(bool)var blocked=false
onready var m=0
enum stts{norm,bridge,laserd,laseru,graw}
func _ready():
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	emit_signal("loado",self)
	type_process()
signal loado(node)
signal changed(node)
func save():
	var save_dict = {
		"path":get_path(),
		"open":open
	}
	return save_dict
func loade(n):
	open=n["open"]

var br=preload("res://matireals/objects/button/bridge.tscn")
var las=preload("res://matireals/objects/button/lasers/laser.tscn")
var lasu=preload("res://matireals/objects/button/lasers/laseru.tscn")
var gr=preload("res://matireals/objects/button/graw_pole/graw.tscn")
var g =Global


func type_process():
	if m==1:
		var m=br.instance()
		m.z_index=-2
		$mode.add_child(m)
	elif m==2:
		var m=las.instance()
		m.z_index=-2
		$mode.add_child(m)
	elif m==3:
		var m=lasu.instance()
		m.z_index=-2
		$mode.add_child(m)
	elif m==4:
		var m=gr.instance()
		m.z_index=-2
		$mode.add_child(m)
	else: null
	pass
func _physics_process(delta):
	
	if body!=null and blocked==false:
		if body.tkd==false:
			$pin.node_b=body.get_path()
			body.set_deferred("global_position",$pin.global_position)
			body.normedo()
			open=true
		else:
			$pin.node_b=get_path()
			open=false
	else:open=false
	if open==false:
		if $mode.get_child_count()>0:
			$mode.get_child(0).queue_free()
	else:
		if $mode.get_child_count()<1:
			type_process()
func _on_a_body_entered(b):
	body=b
	m=body.m
	b.par=self
func _on_a_body_exited(b):
	m=0
	b.par=null
	body=null

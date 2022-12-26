extends Control
var max_varible =0
var min_varible =0
export(String)var text=""
export(String)var varible=null
export(NodePath)var node_path
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var showed=true




signal loado(node)

signal changed(node)
func save():
	var save_dict = {
		"path":get_path(),
		"var":varible,
		"np":node_path,
		"text":$shd.text,
		"value":$vs.value,
		"sh":showed,
		"pos":pos*int(not showed)
	}
	return save_dict
func loade(n):
	varible=n["var"]
	node_path=n["np"]
	$vs.value=n["value"]
	$shd.text=n["text"]
	showed=n["sh"]
	rect_position.y=n["pos"]
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	emit_signal("loado",self)
	$shd.text=text
var changed_=false
func _on_te_text_changed():
	if node_path!=null and get_node(node_path):
		changed_=true
	pass # Replace with function body.
onready var pos=rect_size.y*rect_scale.y-$shd.rect_size.y/2*$shd.rect_scale.y+5
func _process(delta):
	rect_position=rect_position.move_toward(Vector2(rect_position.x,pos*int(not showed)),1000*delta)
	if changed_==true and $te.readonly==true:
		if $te.text=="":$te.text="0"
		var a=get_node(node_path)
		$te.text=$te.text.lstrip("qwertyuiop[]\/asdfghjkl;:zxcvbnm,.<>?-=+_")
		$te.text=$te.text.rstrip("qwertyuiop[]\/asdfghjkl;:zxcvbnm,.<>?-=+_")
		if float($te.text)>$vs.max_value:
			$te.text=str($vs.max_value)
		if float($te.text)<$vs.min_value:
			$te.text=str($vs.min_value)
		$vs.value=float($te.text)
		a.set(varible,$vs.value)
		emit_signal("changed",self)
		changed_=false
	pass
func _on_vs_value_changed(value):
	if node_path!=null and get_node(node_path):
		var a=get_node(node_path)
		$te.text=str($vs.value)
		emit_signal("changed",self)
		a.set(varible,$vs.value)
		
	pass # Replace with function body.


func _on_te_mouse_entered():
	$te.readonly=false
	pass # Replace with function body.


func _on_te_mouse_exited():
	$te.readonly=true
	
	pass # Replace with function body.


func _on_shd_button_down():
	showed=not showed
	emit_signal("changed",self)
	pass # Replace with function body.

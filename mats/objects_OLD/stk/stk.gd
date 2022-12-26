extends Area2D
export(Color)var acol
export(Color)var bcol
#export(Color)var ERRcol

var _in=false
export(bool)var blocked=false
export(bool)var open=false
export(bool)var time_scripted=false
export(bool)var started=false
export(float)var dur=3

var l=[]
func _chk():
	if open==true:
		$p.color=acol
	else:
		$p.color=bcol
signal loado(node)

signal changed(node)
func save():
	var save_dict = {
		"path":get_path(),
		"open":open,
		"blck":blocked,
		"tim":$t.time_left,
		"ts":time_scripted,
		"st":started
	}
	return save_dict
func loade(n):
	open=n["open"]
	time_scripted=n["ts"]
	$t.set("time_left",n["tim"])
	started=n["st"]
	blocked=n["blck"]
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	emit_signal("loado",self)
	if open==true:
		$p.color=acol
	else:
		$p.color=bcol
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if time_scripted==true and started==true:
		$t.start(dur)
		started=false
	if _in==true:
		if Input.is_action_just_pressed("e") and blocked==false:
			if open==false :
				open=true
				started=true
				self.emit_signal("changed",self)
			else:
				open=false
				started=false
				self.emit_signal("changed",self)
	if blocked==true:open=false
	_chk()

func _on_stk_body_entered(body):
	if body==Global.get_hero():
		_in=true
	pass # Replace with function body.


func _on_stk_body_exited(body):
	if body==Global.get_hero():
		_in=false
func _on_t_timeout():
	$t.stop()
	if time_scripted==true:
		open=false
		started=false

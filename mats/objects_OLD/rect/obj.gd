extends RigidBody2D
var vel=Vector2(0,0)
var in_water=false
var post_water=false
var wat_fr=0.85
var p_node=null
enum type {Havy,small}
export(type)var t=type.small
export(float)var gr_power=100
export(float)var gr_ang=90
enum list{norm,bridge,laserd,laseru,graw}
export(list) var m=0
var g=Global
var treveled=false
var in_lvl=-1
onready var pS=get_parent().get_path()
var angle=null
var tkd=false
var con_nod=-1
onready var path=get_path()
onready var ch_path=get_path()
func save():
	var save_dict = {
		"path":path,
		"pathm":ch_path,
		"pos_x" : self.global_position.x, # Vector2 is not supported by JSON
		"pos_y" : self.global_position.y,
		"rot":self.rotation_degrees,
		"m":m,
		"ilvl":in_lvl,
		"id":con_nod,
		"tr":treveled,
	}
	return save_dict
func dead():
	self.free()
	emit_signal("findSN",self)
func loade(n):
	self.set_deferred("global_position",Vector2(n["pos_x"],n["pos_y"]))
	self.set("rotation_degrees",n["rot"])
	self.set("m",n["m"])
	self.set("con_nod",n["id"])
	self.set("in_lvl",n["ilvl"])
	self.set("ch_path",n["pathm"])
	self.set("treveled",n["tr"])
var can_emit=true
func _ready():
	connect("norma",self,"dof")
	self.connect("findSN",Global,"find_data")
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	in_lvl=g.get_lvl(self.get_parent())
			#!=null:queue_free()
	if can_emit==true:
		emit_signal("loado",self)
	#print("KJJFYIUNDCTQ")
signal loado(node)
signal changed(node)
signal findSN(node)
var sleep=false
var lpos=Vector2.ZERO
var par=null
func _integrate_forces(s):
		#
			#ground=true
	if par==null:
		ch_path=get_path()
		vel = s.get_linear_velocity()
		var step = s.get_step()
		if (in_water==false and post_water==false):
			vel +=g.move(gr_ang)*gr_power*gravity_scale*step
		else:
			vel*=wat_fr
			angular_velocity*=wat_fr
	if tkd==false:
		for x in range(0,s.get_contact_count()):
			var ci = s.get_contact_local_normal(x)
			if ci.dot(Vector2(0, -1)) > 0.6:
				vel=Vector2(0,0)
	s.set_linear_velocity(vel)
func _physics_process(delta):
	if tkd==true:
		angular_velocity*=0.5
	if Vector2(int(lpos.x),int(lpos.y))!=Vector2(int(global_position.x),int(global_position.y)):
		self.emit_signal("changed",self)
		lpos=global_position
		sleep=false
	else:
		sleep=true
func normedo():
	self.vel=Vector2.ZERO
	self.rotation_degrees=0
	self.angular_velocity=0

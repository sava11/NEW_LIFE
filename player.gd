extends RigidBody2D
export(float,-180,180)var gr_ang=90
export(float)var gr_power=980
export(Vector2) var speed=Vector2(500,200)
export(Vector2) var acc=Vector2(2500,600)
export(Vector2) var fric=Vector2(1600,4000)
export(float) var airfric=1000
export(float)var jump_power=400
var jumped=false
export(int,1,9999) var MultiJumpMaxValue=1
var manyjumpvalue=0
var treveled=false
export(bool)var walls
export(Vector2)var speedboost=Vector2(1,1)
#export(PoolIntArray)var powers_have 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func save_from_self():
	#var t=[]
	#for e in powers_have:t.append(e)
	return {
		"frx":fric.x,
		"fry":fric.y,
		"acx":acc.x,
		"acy":acc.y,
		"spx":speed.x,
		"spy":speed.y,
		"grang":gr_ang,
		"grpwr":gr_power,
		"px":global_position.x,
		"py":global_position.y,
		"rot":rotation_degrees,
		"jpwr":jump_power,
		"mjmv":MultiJumpMaxValue,
		"mjv":manyjumpvalue,
		"jmpd":jumped,
		"trvld":treveled,
		}
func set_to_self(n):
	fric=Vector2(n["frx"],n["fry"])
	acc=Vector2(n["acx"],n["acy"])
	speed=Vector2(n["spx"],n["spy"])
	gr_ang=n["grang"]
	gr_power=n["grpwr"]
	global_position=Vector2(n["px"],n["py"])
	rotation_degrees=n["rot"]
	jump_power=["jpwr"]
	MultiJumpMaxValue=["mjmv"]
	manyjumpvalue=n["mjv"]
	jumped=n["jmpd"]
	treveled=n["trvld"]

signal SD
signal LD(n)
onready var tl=[$c.shape.height]
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("LD",Global,"load_d")
	connect("SD",Global,"save_nodes")
	#connect()
	pass # Replace with function body.
var ground=false
var wall=false
var vec=Vector2.ZERO
var lvec=Vector2.ZERO
var g=Global
var lv=0
onready var down=$down
var get_up_pos=Vector2.ZERO
var upping=false
func end_upping():upping=false

func get_up():
	if $r2.is_colliding()==false and $r3.is_colliding()==false:
		if $r.is_colliding()==true:pass
			#lvec=Vector2.ZERO
			#set_linear_velocity(lvec)
			#$ap.play("get_up_r",-1,0.1)
			#upping=true
			#get_up_pos=$r.get_collision_point()-global_position-Vector2(0,24)
			#$ap.get_animation("get_up").track_set_key_value(1,0,global_position+g.move(rotation_degrees+90)*-24)
			#$ap.get_animation("get_up").track_set_key_value(0,1,g.move(rotation_degrees)-(global_position+Vector2(get_up_pos.x,0)))
			#$ap.get_animation("get_up").track_set_key_value(1,1,get_up_pos+global_position)
			#$ap.play("get_up")
			#upping=true
		else:
			get_up_pos=Vector2.ZERO
		
var crouch=false
func sit(a,b):
	if b==true:
		$c.shape.height=tl[0]-a
		$c.position.y=+a/2
		crouch=b
	else:
		$c.shape.height=tl[0]
		$c.position.y=0
		crouch=b
func _physics_process(delta):
	#if upping==false:
	#get_up()######################################################################################
	if Input.is_action_just_pressed("crouch"):
		sit(15,true)
	if Input.is_action_just_released("crouch"):
		if $up.is_colliding()==false:
			sit(15,false)
	if wall==true and crouch==true:
		sit(15,false)
	if wall==false and Input.is_action_pressed("crouch") and crouch==false:
		sit(15,true)
func modern_walk(wl,step):
	if wall and jumped==false :
		if vec.x>wl or vec.x<wl:
			if vec.x==0 and ground==false and down.is_colliding()==false:
				set_linear_velocity(Vector2.ZERO)
				lvec.x=0
			if vec.y!=0:
				if vec.y>lvec.normalized().y or vec.y<lvec.normalized().y:
					lvec.y=lvec.move_toward(vec*speed.y,step*fric.y*speedboost.y).y
				else:
					lvec.y=lvec.move_toward(vec*speed.y,step*acc.y*speedboost.y).y
			else:
				lvec.y=lvec.move_toward(Vector2.ZERO,step*fric.y*speedboost.y).y
		else: lvec.y=lvec.move_toward(Vector2.ZERO,step*fric.y*speedboost.y).y
	
	if ground or down.is_colliding()==true:
		if vec.x!=0 :
			if vec.x>lvec.normalized().x or vec.x<lvec.normalized().x:
				lvec.x=lvec.move_toward(vec*speed.x,step*fric.x*speedboost.x).x
			else:
				lvec.x=lvec.move_toward(vec*speed.x,step*acc.x*speedboost.x).x
		else:
			lvec.x=lvec.move_toward(Vector2.ZERO,step*fric.x*speedboost.x).x
	if ground==false and wall==false :
		if vec.x!=0 :
			if vec.x>=lvec.normalized().x or vec.x<=lvec.normalized().x:
				lvec.x=lvec.move_toward(vec*speed.x,step*airfric*speedboost.x).x
			else:
				lvec.x=lvec.move_toward(vec*speed.x,step*airfric*speedboost.x).x
		else:
			lvec.x=lvec.move_toward(Vector2.ZERO,step*airfric*speedboost.x).x
func _integrate_forces(st):
	if upping==false:
		var step=st.get_step()
		lvec=g.move((180/PI)*g.angle(st.get_linear_velocity())-lv)*g._sqrt(st.get_linear_velocity())
		ground=false
		wall=false 
		var jpressed=Input.is_action_pressed("jump")
		var jpress=Input.is_action_just_pressed("jump")
		
		#for x in range(st.get_contact_count()):
		#	var ci = st.get_contact_local_normal(x)
		#	if ci.dot(Vector2(0, -1)) >= 0.6:
		#		ground=true
		#	if ci.dot(Vector2(-1, 0)) > 0.6 or ci.dot(Vector2(1, 0)) > 0.6:
		#		wall=true and walls==true
		
		var wl=0
		for x in range(st.get_contact_count()):
			var ci = st.get_contact_local_normal(x)
			if ci.dot(g.move(rotation_degrees)) > 0.1:
				wl=1
			if ci.dot(g.move(rotation_degrees-180)) > 0.6:
				wl=-1
			if ci.dot(g.move(rotation_degrees-90)) >= 0.6:
				ground=true
			if ci.dot(g.move(rotation_degrees-180)) > 0.6 or ci.dot(g.move(rotation_degrees)) > 0.6:
				wall=true and walls==true
		if wall or ground:
			if jumped==false :
				manyjumpvalue=0
			if int(lvec.y)>=0:
				jumped=false
		vec =Vector2(Input.get_action_strength("d")-Input.get_action_strength("a"),Input.get_action_strength("s")-Input.get_action_strength("w"))
		if upping==false:
			if vec.x!=0 and wall==false:
				$r.position.x=15*vec.x
				$r2.position.x=15*vec.x
				$r3.position.x=5*vec.x
				$r4.position.x=5*vec.x
				$r3.cast_to.x=vec.x*15
				$r4.cast_to.x=vec.x*15
			#lvec=vec*speed
			modern_walk(wl,step)
			if ground==false and wall and jpress and down.is_colliding()==false and (not(vec.x>wl or vec.x<wl)or vec.x==0):
				lvec=speed.x*vec.normalized() 
				jumped=true
			if jpress and manyjumpvalue<MultiJumpMaxValue and (wall==false and ground):
				lvec.y=0
				lvec+=g.move(-90)*jump_power
				manyjumpvalue+=1
				jumped=true
				#set_disable(false)
			if jpressed==true and jumped==true:
				lvec.x+=vec.x*jump_power/50
				
				
			
			##########
		if (ground==false and  wall==false) or jumped:
			lvec+=g.move(gr_ang)*gr_power*gravity_scale*step
		st.set_linear_velocity(g.move((180/PI)*g.angle(lvec)+rotation_degrees)*g._sqrt(lvec))
		lv=rotation_degrees

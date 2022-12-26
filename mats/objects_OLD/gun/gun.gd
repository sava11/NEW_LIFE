extends RigidBody2D

export(String)var gun_name="name"
export(int)var kalibr_id=0
export(float)var dmg=1
var sh_time=0
var rel_time=0
export(int)var ammos=30
export(float)var shout_time=0.1
export(float)var reload_time=1.75
export(int)var magazin_value=3
var magazins=[]
var magazins_ammos=ammos
export(float)var bullet_damage=1
export(float)var bullet_scale_damage=1
export(float)var bullet_speed=60
export(float)var bullet_shout_out=900
var bullet=preload("res://matireals/objects/bullet/ammo.tscn")
func attack():
	var b=bullet.instance()
	var bv = Vector2(cos(deg2rad(global_rotation_degrees)),sin(deg2rad(global_rotation_degrees)))*bullet_speed
	b.rotation=global_rotation
	b.collision_mask=17+64
	b.global_position = $b_pos.global_position
	b.get_node("c").position.x=Global._sqrt(bv)/2
	b.get_node("c").shape.set_deferred("height",Global._sqrt(bv)/2)
	b.get_node("hitbox").speed=bullet_speed
	b.set_linear_velocity(bv*b.get_node("hitbox").speed)
	b.get_node("hitbox").shout_out_scale=bullet_shout_out
	b.get_node("hitbox").scale_damage=bullet_scale_damage
	b.get_node("hitbox").damage=bullet_damage
	b.get_node("hitbox").collision_mask=9+64
	#b.get_node("hitbox").collision_mask=9
	get_tree().current_scene.call_deferred("add_child",b)
var old_mvalue=0
func upd_magzs():
	if old_mvalue<magazin_value:
		for m in range(old_mvalue,magazin_value):
			magazins.append(magazins_ammos)
	old_mvalue=magazin_value
func _ready():
	upd_magzs()
	self.connect("changed",Global,"save_nodes")
	self.connect("loado",Global,"load_d")
	$c/p.polygon=$c.polygon
signal loado(node)
signal changed(node)
func save_info():
	var save_dict = {
		"path":get_path(),
		"name":gun_name,
		"selfdmg":dmg,
		"ammos":ammos,
		"shout_time":shout_time,
		"magazins":magazins,
		"magazins_ammos":magazins_ammos,
		"reload_time":reload_time,
		"bullet_damage":bullet_damage,
		"bullet_scale_damage":bullet_scale_damage,
		"bullet_speed":bullet_speed,
		"bullet_shout_out":bullet_shout_out
	}
	return save_dict
func save():
	var save_dict = {
		"path":get_path(),
		"name":gun_name,
		"rot":rotation_degrees,
		"posy":global_position.y,
		"posx":global_position.x,
		"selfdmg":dmg,
		"ammos":ammos,
		"shout_time":shout_time,
		"magazins":magazins,
		"magazins_ammos":magazins_ammos,
		"reload_time":reload_time,
		"bullet_damage":bullet_damage,
		"bullet_scale_damage":bullet_scale_damage,
		"bullet_speed":bullet_speed,
		"bullet_shout_out":bullet_shout_out
	}
	return save_dict
func loade(n):
	gun_name=n["name"]
	dmg=n["selfdmg"]
	ammos=n["ammos"]
	shout_time=n["shout_time"]
	magazins=n["magazins"]
	magazins_ammos=n["magazins_ammos"]
	reload_time=n["reload_time"]
	bullet_damage=n["bullet_damage"]
	bullet_scale_damage=n["bullet_scale_damage"]
	bullet_speed=n["bullet_speed"]
	bullet_shout_out=n["bullet_shout_out"]
	rotation_degrees=n["rot"]
	global_position=Vector2(n["posx"],n["posy"])
func load_info(n):
	gun_name=n["name"]
	dmg=n["selfdmg"]
	ammos=n["ammos"]
	shout_time=n["shout_time"]
	magazins=n["magazins"]
	magazins_ammos=n["magazins_ammos"]
	reload_time=n["reload_time"]
	bullet_damage=n["bullet_damage"]
	bullet_scale_damage=n["bullet_scale_damage"]
	bullet_speed=n["bullet_speed"]
	bullet_shout_out=n["bullet_shout_out"]
var d=0
var on_arm=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	d=delta
	if Global.guns.find(self.gun_name)!=-1 and get_parent().get_parent()!=Global.get_hero():
		queue_free()
	if inn!=null and inn.take==true:
		var t=load("res://matireals/objects/gun/gun.tscn").instance()
		t.mode=RigidBody2D.MODE_STATIC
		inn.get_node("guns").call("add_child",t)
		t.load_info(self.save_info())
		t.position=Vector2.ZERO
		t.remove_child(t.find_node("ar"))
		t.visible=false
		get_parent().remove_child(self)
		if Global.guns.find(self.gun_name)==-1:
			Global.guns.append(self.gun_name)
	if on_arm==true:
		if magazins!=[]:
			if Input.is_action_pressed("reload"):
				reload()
				
			else:
				rel_time=0
		else:
			if Input.is_action_just_pressed("reload"):
				print("you haven't magazins for "+gun_name)
				
signal attacking()

func reload():
	rel_time+=d
	if rel_time>=reload_time and ammos<magazins_ammos:
		for z in magazins:
			if z==0:
				magazins.remove(magazins.find(z))
		if ammos!=0:
			magazins.append(ammos)
		ammos=magazins[0]
		magazins.remove(0)
		rel_time=0
var inn=null
func _on_ar_body_entered(b):
	inn=b
func _on_ar_body_exited(b):
	inn=null
func get_text_info():
	return "gun_name: "+gun_name+"\nmagazins: "+str(magazins)+"\nammos: "+str(ammos) 


func _on_gun_attacking():
	sh_time+=d
	if sh_time>=shout_time and ammos>0:
		attack()
		ammos-=1
		sh_time=0

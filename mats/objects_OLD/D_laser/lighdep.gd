extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export(Vector2)var leight_XY
export(float)var he=10
export(bool)var open=true
export(bool)var blocked=false
onready var h=$h
onready var col=$h/col
onready var r=$r
func save():
	var sl={
		"path":get_path(),
		"open":open,
		"blck":blocked,
	}
func loade(n):
	open=n["open"]
	blocked=n["blck"]
func _physics_process(delta):
	if open==true and blocked==false:
		if r.is_colliding()==true:
			h.monitorable=true
			h.monitoring=true
			$link.visible=true
			var rt=r.get_collision_point()-global_position
			var leight=sqrt(rt.x*rt.x+rt.y*rt.y)
			$link.scale=Vector2(leight,he)/($link.texture.get_size()*Vector2(1,$link.material.get("shader_param/thickness")+$link.material.get("shader_param/outline_thickness")))
			col.shape.extents=Vector2(he/2,leight/2)
			if r.get_collider().is_in_group("lch"):
				$p.emitting=false
				$p.position=Vector2(0,0)
			else:
				$p.emitting=true
				$p.position=Vector2(0,leight)
			h.position=Vector2(0,leight/2)
		else:
			$link.visible=false
			$p.emitting=false
			$p.position=Vector2(0,0)
			h.monitorable=false
			h.monitoring=false
	else:
		$link.visible=false
		$p.emitting=false
		$p.position=Vector2(0,0)
		h.monitorable=false
		h.monitoring=false

extends Node2D
export(bool) var enebled=true
export(float)var up=100#
export(bool)var auto_up=false
export(float)var speed=100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var pos=position.y
# Called when the node enters the scene tree for the first time.
func _ready():
	if auto_up==true:
		var t=get_node("p/p/c").polygon
		var maxX=0
		for e in t:
			if e.y>maxX:
				maxX=e.y
		up=maxX
	pass # Replace with function body.
onready var p=$p#st.get_linear_velocity()
func _physics_process(delta):
	p.position.y=move_toward(p.position.y,-up*int(enebled),delta*speed)

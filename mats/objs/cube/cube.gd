extends RigidBody2D
export(float,-180,180)var gr_ang=90.0
export(float)var gr_power=980.0
var vec=Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const g =Global

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _integrate_forces(st):
	vec=st.get_linear_velocity()
	var step=st.get_step()
	#g.move((180/PI)*g.angle(lvec)+rotation_degrees)*g._sqrt(lvec)
	vec+=g.move(gr_ang)*gr_power*gravity_scale*step
	st.set_linear_velocity(vec)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

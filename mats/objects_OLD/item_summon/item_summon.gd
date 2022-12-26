extends RigidBody2D
enum Type{J2,MJump,wall_move}
export(Type) var item_type = Type.J2
enum Eff_Type{None,magic,portal,lines,bugs}
export(Eff_Type) var item_eff_type = Eff_Type.None
var id=0
var can_take=false
var b
func _ready():
	id=get_parent().get_child_count()
	#if item_type==Type.sp_notwork:
		#$s.texture=load("res://matireals/images/sprint.png")

func _physics_process(delta):
	#J2,MJump,hook,wall_move
	if (item_type==0 and Global.taked_jupers==true) or (item_type==1 and Global.mega_jump==true) or (item_type==2 and Global.can_wall==true):
		queue_free()
	if get_tree().paused == false and Input.is_action_just_pressed("e") and b==Global.get_hero() and can_take==true:
		if item_type==0:
			Global.taked_jupers=true
			Global.get_hero().MultiJumpMaxValue+=1
		if item_type==1:
			Global.get_hero().mega_moves+=1
			Global.mega_jump=true
		if item_type==2:
			Global.can_wall=true
		queue_free()
			
func _on_a_body_entered(body):
	if body==Global.get_hero():
		can_take=true
		b=body


func _on_a_body_exited(body):
	if body==Global.get_hero():
		can_take=false
		b=null

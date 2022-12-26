extends Node2D
export(int) var w_range=32
onready var st_p=global_position
onready var t_pos=global_position
func _ready():
	upd_t_pos()
func upd_t_pos():
	var t_v=Vector2(rand_range(-w_range,w_range),0)
	t_pos=st_p+t_v
func get_t_left():
	return $Timer.time_left
func set_w_t(dur):
	$Timer.start(dur)
func _on_Timer_timeout():
	upd_t_pos()

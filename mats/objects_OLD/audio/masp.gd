extends Node2D
export(float)var time=0
export(float)var attenuation=1
var sec_time=0
export(AudioStreamSample)var asm
enum t{all, d2, d3,}
export(t) var exto
export(String)var busName="main_menu"
export(float)var volume_db_2_3_d=0
export(bool) var play=false
signal loado(node)
signal changed(node)
func save():
	if get_child(0)!=null:
		print("yis")
		var save_dict = {
			"path":get_path(),
			"time":get_child(0).get_playback_position()
		}
		return save_dict
	else:
		print("null")
		var save_dict = {
			"path":get_path(),
			"time":null,
			"play":play
		}
		return save_dict
func loade(n):
	var asp=null
	if exto==t.d2:
		asp = AudioStreamPlayer2D.new()
		asp.volume_db=volume_db_2_3_d
	if exto==t.all:
		asp = AudioStreamPlayer.new()
		asp.volume_db=volume_db_2_3_d
	if exto==t.d3:
		asp = AudioStreamPlayer3D.new()
	add_child(asp)
	asp.stream=asm
	asp.bus=busName
	asp.play(n["time"])
	asp.set_process(true)
	if not asp is AudioStreamPlayer:
		asp.attenuation=attenuation
	sec_time=n["time"]
	play=n["play"]
	pass
	#$t.set("time_left",n["tim"])
func _process(delta):
	sec_time+=delta
	for e in get_children():
		if e.playing==false:
			e.queue_free()
	if play==true and time>0 and (sec_time>=time or get_child_count()==0):
		var asp=null
		if exto==t.d2:
			asp = AudioStreamPlayer2D.new()
			asp.volume_db=volume_db_2_3_d
		if exto==t.all:
			asp = AudioStreamPlayer.new()
			asp.volume_db=volume_db_2_3_d
		if exto==t.d3:
			asp = AudioStreamPlayer3D.new()
		add_child(asp)
		asp.stream=asm
		asp.bus=busName
		asp.play()
		asp.set_process(true)
		if not asp is AudioStreamPlayer:
			asp.attenuation=attenuation
		sec_time=0
	
	if play==false:
		for e in get_children():
			e.queue_free()

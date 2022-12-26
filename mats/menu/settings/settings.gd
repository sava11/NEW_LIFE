extends Panel
export(float,0.001,1) var scale=0.5
var wins=[[800, 600], [854, 480], [960, 540], [1024, 600], [1024, 768], [1152, 864], [1200, 600], [1280, 720], [1280, 768], [1280, 1024], [1408, 1152], [1440, 900], [1400, 1050], [1440, 1080], [1536, 960], [1536, 1024], [1600, 900], [1600, 1024], [1600, 1200], [1680, 1050], [1920, 1080], [1920, 1200], [2048, 1080], [2048, 1152], [2048, 1536], [2560, 1080], [2560, 1440], [2560, 1600], [2560, 2048], [3200, 1800], [3200, 2048], [3200, 2400], [3440, 1440], [3840, 2160], [3840, 2400], [4096, 2160], [5120, 2880], [5120, 4096], [6400, 4096], [6400, 4800], [7680, 4320], [7680, 4800], [10240, 6480], [11520, 6480]]
# Called when the node enters the scene tree for the first time.

var st_aud_list_sound=[]
func _ready():
	var dir=Directory.new()
	var items=[]
	for w in wins:
		items.append(str(w[0])+"x"+str(w[1]))
		items.append(Object(null))
		items.append(false)
		items.append(wins.find(w))
		items.append(null)
	$hbc/OptionButton.items=items
	if dir.file_exists(g.mres+g.paths[1]+"/Options.opt"):
		loado()
	for e in range(0,AudioServer.get_bus_count()):
		st_aud_list_sound.append(AudioServer.get_bus_volume_db(e))
signal resolution_changed(new_resolution)
var g=Global
onready var option_button: OptionButton = $hbc/OptionButton
func _update_selected_item(text: String) -> void:
	var values := text.split_floats("x")
	emit_signal("resolution_changed", Vector2(values[0], values[1]))
var w=ProjectSettings.get("display/window/size/width")
var h=ProjectSettings.get("display/window/size/height")
func save():
	var save_dict = {
		"path":get_path(),
		"res_x":_settings.resolution.x,
		"res_y":_settings.resolution.y,
		"FC":_settings.fullscreen,
		"Vsync":_settings.vsync,
		"MMAV":$menu_sound.value,
		"BMAV":$button_sound.value,
		"fn":g.fname,
	}
	return save_dict
func save_data():
	var save_game = File.new()
	var dir=Directory.new()
	save_game.open(g.mres+g.paths[1]+"/Options.opt", File.WRITE)
	save_game.store_line(to_json(save()))
	save_game.close()
func loade(n):
	OS.window_fullscreen = n["FC"]
	_settings.resolution=Vector2(int(n["res_x"]),int(n["res_y"]))
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(int(n["res_x"]),int(n["res_y"])))
	ProjectSettings.set("display/window/size/width",int(n["res_x"]))
	ProjectSettings.set("display/window/size/height",int(n["res_y"]))
	OS.set_window_size(Vector2(int(n["res_x"]),int(n["res_y"])))
	OS.vsync_enabled = n["Vsync"]
	$fullscreen/CheckBox.pressed=n["FC"]
	$vsync/CheckBox.pressed=n["Vsync"]
	$menu_sound.value=n["MMAV"]
	$button_sound.value=n["BMAV"]
	var screen_size = OS.get_screen_size(0)
	OS.set_window_position(screen_size*0.5 - Vector2(int(n["res_x"]),int(n["res_y"]))*0.5)
	g.fname=n["fn"]
	$hbc/OptionButton.selected=wins.find([int(n["res_x"]),int(n["res_y"])])
func loado():
	var save_game = File.new()
	save_game.open(g.mres+g.paths[1]+"/Options.opt", File.READ)
	var sn=parse_json(save_game.get_line())
	save_game.close()
	loade(sn)
func _process(delta):
	w=ProjectSettings.get("display/window/size/width")
	h=ProjectSettings.get("display/window/size/height")
	rect_size=Vector2(w,h)*scale
	rect_position=Vector2(w,h)*scale-rect_size/2
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("main_menu"), linear2db($menu_sound.value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("buttons"), linear2db($button_sound.value*2)+st_aud_list_sound[AudioServer.get_bus_index("buttons")])
	#print(wins.find([w,h]))
func _on_OptionButton_item_selected(_index: int) -> void:
	_update_selected_item(option_button.text)

func update_settings(settings: Dictionary) -> void:
	OS.window_fullscreen = settings.fullscreen
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, settings.resolution)
	ProjectSettings.set("display/window/size/width",settings.resolution[0])
	ProjectSettings.set("display/window/size/height",settings.resolution[1])
	OS.set_window_size(settings.resolution)
	OS.vsync_enabled = settings.vsync
	#get_tree().current_scene.get_node("cl/main_menu").call_deferred("change_m")
	var screen_size = OS.get_screen_size(0)
	OS.set_window_position(screen_size*0.5 - settings.resolution*0.5)

signal apply_button_pressed(settings)

var _settings := {resolution = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height")), fullscreen = false, vsync = false}


func _on_ApplyButton_pressed() -> void:
	emit_signal("apply_button_pressed", _settings)
	save_data()


func _on_UIResolutionSelector_resolution_changed(new_resolution: Vector2) -> void:
	_settings.resolution = new_resolution


func _on_UIFullscreenCheckbox_toggled(is_button_pressed: bool) -> void:
	_settings.fullscreen = is_button_pressed


func _on_UIVsyncCheckbox_toggled(is_button_pressed: bool) -> void:
	_settings.vsync = is_button_pressed


func _on_OptionButton_button_down():
	g.menu_history.append(g.menu_history_items.RES)


func ex():
	if g.program_history[len(g.program_history)-1]==g.program_history_items.menu:
		g.bac_his()
	if g.program_history[len(g.program_history)-1]==g.program_history_items.game:
		g.bac_his_g()
	pass # Replace with function body.

extends Node

const MainMenu_SCENE = "res://MainMenu.tscn"

var master_bus = AudioServer.get_bus_index("Master")
var bgm_bus = AudioServer.get_bus_index("BGM")
var sfx_bus = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var back_button = get_node_or_null("BackButton")
	#back_button.connect("pressed", _on_back_button_pressed)
	if Cursor.disabled:
		$CursorButton.button_pressed = true
	else:
		$CursorButton.button_pressed = false
	#if Cursor.window:
		#$WindowButton.button_pressed = true
	#else:
		#$WindowButton.button_pressed = false

func _on_back_button_pressed() -> void:
	Sfx.play_sound("Buttonclick")
	if not Cursor.settings:
		get_tree().change_scene_to_file(MainMenu_SCENE)
	else:
		$"..".visible = false
		Cursor.settings = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, value)
	
	
	if value == 0:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
		

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	
	AudioServer.set_bus_volume_db(sfx_bus, value)
	
	if value == 0:
		AudioServer.set_bus_mute(sfx_bus, true)
	else:
		AudioServer.set_bus_mute(sfx_bus, false)
	
func _on_background_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgm_bus, value)
	
	if value == 0:
		AudioServer.set_bus_mute(bgm_bus, true)
	else:
		AudioServer.set_bus_mute(bgm_bus, false)

#Hover sound effects.
func _on_master_volume_slider_drag_ended(value_changed: bool) -> void:
	Sfx.play_sound("Slidedrop")

func _on_sfx_volume_slider_drag_ended(value_changed: bool) -> void:
	Sfx.play_sound("Slidedrop")

func _on_background_volume_slider_drag_ended(value_changed: bool) -> void:
	Sfx.play_sound("Slidedrop")

func _on_back_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_cursor_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Cursor.disabled = true
	else:
		Cursor.disabled = false

func _on_cursor_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_cursor_button_pressed() -> void:
	Sfx.play_sound("Buttonclick")

#func _on_window_button_pressed() -> void:
	#Sfx.play_sound("Buttonclick")
#
#func _on_window_button_toggled(toggled_on: bool) -> void:
	#if toggled_on:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#DisplayServer.window_set_size(Vector2i(1280,720))
		#Cursor.window = true
	#else:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		#DisplayServer.window_set_size(Vector2i(1440,1080))
		#Cursor.window = false
#
#func _on_window_button_mouse_entered() -> void:
	#Sfx.play_sound("Buttonhover")

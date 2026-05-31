extends Control

#Loads in images.
var CursorDefault = load("res://PlaceholderArt/Cursor1.png")
var CursorClick = load("res://PlaceholderArt/Cursor2.png")
var CrosshairGreen = load("res://Art/Player/fishCrosshairGreen.png")
#States of cursor.
var in_gameplay = false #Is hunter within bounds of gameplay.
var standby = true #Is hunter on standby?
var timeout = false #Is hunter waiting to shoot?
var shoot = false #Is hunter shooting?
var reloading = false #Is hunter reloading?
var shotposition : Vector2 #The position that the hunter shot at.
var randomminoffset = -5 #The lowest number of pixels that the cursor will randomly be moved by.
var randommaxoffset = 5 #The highest number of pixels that the cursor will randomly be moved by.
#Misc
var settings = false #Is the player accessing the menu from pause menu?
var disabled = false #Did the player disable the custom cursors?
var compete = true #Did the player toggle the compete mode?
var window = false #Did the player toggle windowed mode?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(CursorDefault, 0, Vector2(3, 3))

func _process(delta: float) -> void:
	if not in_gameplay:
		if !disabled:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				Input.set_custom_mouse_cursor(CursorClick, 0, Vector2(3, 3))
			else: 
				Input.set_custom_mouse_cursor(CursorDefault, 0, Vector2(3, 3))
		else:
			Input.set_custom_mouse_cursor(null)
	else:
		if reloading:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.warp_mouse(shotposition)
		elif standby:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			if !disabled:
				Input.set_custom_mouse_cursor(CrosshairGreen, 0, Vector2(96, 96))
			else:
				Input.set_custom_mouse_cursor(null)
			Input.warp_mouse(Vector2(get_global_mouse_position().x + randf_range(randomminoffset, randommaxoffset), get_global_mouse_position().y + randf_range(randomminoffset, randommaxoffset)))
		elif timeout:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.warp_mouse(shotposition)
		elif shoot:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.warp_mouse(shotposition)

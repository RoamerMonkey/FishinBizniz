extends CanvasLayer

const MainMenu_SCENE = "res://MainMenu.tscn"
var currentTab = 1
var randomminoffset = -5 #The lowest number of pixels that the cursor will randomly be moved by.
var randommaxoffset = 5 #The highest number of pixels that the cursor will randomly be moved by.
var timeouttime = 1.25 #How long does it take for the gun to shoot upon clicking.
var reloadtime = 0.5 #How long it takes to reload each bullet.
var bulletmax = 3 #Max number of bullets.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var back_button = get_node_or_null("BackButton")
	#back_button.connect("pressed", _on_back_button_pressed)

func _on_back_button_pressed() -> void:
	Sfx.play_sound("Buttonclick")
	if not Cursor.settings:
		get_tree().change_scene_to_file(MainMenu_SCENE)
	else:
		$"..".visible = false
		Cursor.settings = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentTab == 1:
		$LArrowButton.disabled = true
		$RArrowButton.disabled = false
		$Tab1.visible = true
		$Tab2.visible = false
	elif currentTab == 2:
		$LArrowButton.disabled = false
		$RArrowButton.disabled = true
		$Tab1.visible = false
		$Tab2.visible = true

func _on_l_arrow_button_pressed() -> void:
	currentTab -= 1
	Sfx.play_sound("Buttonclick")

func _on_r_arrow_button_pressed() -> void:
	currentTab += 1
	Sfx.play_sound("Buttonclick")

func _on_back_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_l_arrow_button_mouse_entered() -> void:
	if currentTab != 1:
		Sfx.play_sound("Buttonhover")

func _on_r_arrow_button_mouse_entered() -> void:
	if currentTab != 2:
		Sfx.play_sound("Buttonhover")

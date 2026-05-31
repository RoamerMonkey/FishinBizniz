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
		$".".visible = false
		Cursor.settings = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentTab == 1:
		$LArrowButton.disabled = true
		$Tab1.visible = true
		$Tab2.visible = false
	elif currentTab == 2:
		$LArrowButton.disabled = false
		$Tab1.visible = false
		$Tab2.visible = true
		$Tab3.visible = false
	elif currentTab == 3:
		$RArrowButton.disabled = false
		$Tab2.visible = false
		$Tab3.visible = true
		$Tab4.visible = false
	elif currentTab == 4:
		$RArrowButton.disabled = true
		$Tab3.visible = false
		$Tab4.visible = true

func _physics_process(delta: float) -> void:
	$Tab4/Crosshair1.position.x = clamp($Tab4/Crosshair1.position.x, -5, 5)
	$Tab4/Crosshair1.position.y = clamp($Tab4/Crosshair1.position.x, 434, 444)
	$Tab4/Crosshair1.position = Vector2($Tab4/Crosshair1.position.x + randf_range(randomminoffset, randommaxoffset), $Tab4/Crosshair1.position.y + randf_range(randomminoffset, randommaxoffset))

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
	if currentTab != 4:
		Sfx.play_sound("Buttonhover")

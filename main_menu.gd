extends Control

# Change these paths to match the actual scenes in your project
const START_SCENE = "res://gameplay.tscn"
const SETTINGS_SCENE = "res://settings.tscn"
const HELP_SCENE = "res://help.tscn"
const CREDITS_SCENE = "res://credits.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	Bgm.play()
	Bgm.get_stream_playback().switch_to_clip_by_name("Main")
	
	var start_button = get_node_or_null("StartButton")
	var settings_button = get_node_or_null("SettingsButton")
	var quit_button = get_node_or_null("QuitButton")
	var help_button = get_node_or_null("HelpButton")
	var credits_button = get_node_or_null("CreditsButton")

	#if start_button: 
		#start_button.connect("pressed", _on_start_button_pressed)
		#
	#else:
		#print("Error: StartButton not found!")
#
	#if settings_button:
		#settings_button.connect("pressed", _on_settings_button_pressed)
	#else:
		#print("Error: SettingsButton not found!")
#
	#if quit_button:
		#quit_button.connect("pressed", _on_quit_button_pressed)
	#else:
		#print("Error: QuitButton not found!")

# Function to change to the start scene
func _on_start_button_pressed():
	Sfx.play_sound("Buttonclick")
	$ModeSelection.visible = true

# Function to change to the settings scene
func _on_settings_button_pressed():
	Sfx.play_sound("Buttonclick")
	Transition.load_scene(SETTINGS_SCENE)

# Function to change to the help scene.
func _on_help_pressed() -> void:
	Sfx.play_sound("Buttonclick")
	Transition.load_scene(HELP_SCENE)

# Function to quit the game
#func _on_quit_button_pressed():
	#Sfx.play_sound("Buttonclick")
	#get_tree().quit()

# Function to change to credits scene.
func _on_credits_button_pressed() -> void:
	Sfx.play_sound("Buttonclick")
	Transition.load_scene(CREDITS_SCENE)

#Hover sound effects.
func _on_start_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_settings_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_help_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

#func _on_quit_button_mouse_entered() -> void:
	#Sfx.play_sound("Buttonhover")

func _on_back_button_pressed() -> void:
	Sfx.play_sound("Buttonclick")
	$ModeSelection.visible = false

func _on_back_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_compete_pressed() -> void:
	Sfx.play_sound("Buttonclick")
	Cursor.compete = true
	Transition.load_scene(START_SCENE)

func _on_compete_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_collab_pressed() -> void:
	Sfx.play_sound("Buttonclick")
	Cursor.compete = false
	Transition.load_scene(START_SCENE)

func _on_collab_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_quit_button_pressed() -> void:
	Sfx.play_sound("Buttonclick")
	get_tree().quit()

func _on_quit_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

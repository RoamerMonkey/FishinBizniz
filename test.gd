extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#print("OPEN")
	if event.is_action_pressed("click"):
		print("CLICK")
		#Sfx.play_sound("Buttonclick")

func _on_mouse_entered() -> void:
	print("HOVER")
	#Sfx.play_sound("Buttonhover")

func _on_mouse_exited() -> void:
	print("EXIT")
	#Sfx.play_sound("Buttonplay")

func _on_texture_button_button_down() -> void:
	print("PRESSED")

extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BG.visible = false

func load_scene(next : String):
	$BG.visible = true
	$Animate.play("Fade")
	await $Animate.animation_finished
	get_tree().change_scene_to_file(next)
	$Animate.play_backwards("Fade")
	$BG.visible = false

# Begin fade out transition.
func reload_scene():
	$BG.visible = true
	$Animate.play("Fade")
	await $Animate.animation_finished
	get_tree().reload_current_scene()
	$Animate.play_backwards("Fade")
	$BG.visible = false

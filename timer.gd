extends Control

@export var timeleftmin = 1
@export var timeleftsec = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimerLabel.text = str(timeleftmin) + ":0" + str(timeleftsec)

func _on_timer_timeout() -> void:
	if $"../..".paused == false:
		if timeleftsec == 0 and timeleftmin > 0:
			timeleftmin -= 1
			timeleftsec = 60
		timeleftsec -= 1
		if timeleftsec > 9:
			$TimerLabel.text = str(timeleftmin) + ":" + str(timeleftsec)
		else:
			$TimerLabel.text = str(timeleftmin) + ":0" + str(timeleftsec)
		if timeleftsec == 0 and timeleftmin <= 0:
			$"../..".roundover = true
		if timeleftmin == 0 and timeleftsec == 30:
			$TimerLabel.set("theme_override_colors/font_color", Color("ff7059"))
			Sfx.play_sound("Round30Seconds")
		elif timeleftmin == 0 and timeleftsec <= 10:
			$TimerLabel.set("theme_override_colors/font_color", Color("f02f00"))
			Sfx.play_sound("RoundCountdown")

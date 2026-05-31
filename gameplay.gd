extends Node2D

@export_group("Hook Variables")
@export var initialspeed = 3.5 #The default speed of the hook.
@export var hookspeed = initialspeed #The current speed of the hook.
@export var standby = true #Is the hook on standby at the top of the screen.
@export var goingdown = false #Is the hook going down?
@export var goingup = false #Is the hook going up?
@export var itemname : Area2D #What item did the hook grab?
@export var itemhooked = false #Is an item being hooked?

@export_group("Gun Variables")
@export var bulletnum = 3 #Current number of bullets.
@export var bulletmax = 3 #Max number of bullets.
@export var timeouttime = 1.25 #How long does it take for the gun to shoot upon clicking.
@export var shoottime = 0.5 #How long it takes for the gun to be shooting.
@export var reloadtime = 0.5 #How long it takes to reload each bullet.
@export var shotgot = false #Did the hunter successfully shoot at a fish?

@export_group("Game Variables")
@export var fisherscore = 0 #Fisher's current score
@export var hunterscore = 0 #Hunter's current score
@export var coinpoint = 200 #Number of points that a coin rewards
@export var normalfishpoint = 100 #Number of points that a standard fish rewards
@export var wantedfishpoint = 200 #Number of points that a standard fish rewards
@export var wantedfishername : String #Fisher's wanted fish name.
@export var wantedhuntername : String #Hunter's wanted fish name.
@export var offlimitfishpoint = -100 #Number of points that a off-limits fish rewards
@export var offlimitfishername : String #Fisher's off-limits fish name.
@export var offlimithuntername : String #Hunter's off-limits fish name.
@export var dudfishpoint = 0 #Number of points that a dud fish rewards
@export var dudfishername : String #Fisher's dud fish name.
@export var dudhuntername : String #Hunter's dud fish name.

@export_group("Round Variables")
@export var start = false #Has the round started yet?
@export var roundover = false #Is the round over yet?
@export var paused = true #Is the game paused?

@export_group("Fish Variables")
@export var spawn = true #Will the fish spawn?
@export var RFish = preload("res://Fish/RFish.tscn")
@export var OFish = preload("res://Fish/OFish.tscn")
@export var YFish = preload("res://Fish/YFish.tscn")
@export var GFish = preload("res://Fish/GFish.tscn")
@export var BFish = preload("res://Fish/BFish.tscn")
@export var PFish = preload("res://Fish/PFish.tscn")
@export var WFish = preload("res://Fish/WFish.tscn")
@export var ZFish = preload("res://Fish/ZFish.tscn")
@export var fishcount = 0 #Number of on-screen fish
@export var fishmax = 20 #Limit of on-screen fish
@export var spawnfish : String #What is the fish being spawned?
@export var shotfish : Area2D #What fish did the hunter shoot at?

@export_group("Misc Variables")
@export var zindex = 1 #The z-index of the shader.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Bgm.get_stream_playback().switch_to_clip_by_name("Silence")
	#Selects the fisher and hunter's designated fish for the round.
	var currentfishlist = ["RFish", "OFish", "YFish", "GFish", "BFish", "PFish", "WFish", "ZFish"]
	var randomfish = currentfishlist.pop_at(randi_range(0, len(currentfishlist) - 1))
	wantedfishername = randomfish
	updatefish(randomfish, "wantedfisher")
	randomfish = currentfishlist.pop_at(randi_range(0, len(currentfishlist) - 1))
	dudfishername = randomfish
	updatefish(randomfish, "dudfisher")
	randomfish = currentfishlist.pop_at(randi_range(0, len(currentfishlist) - 1))
	offlimitfishername = randomfish
	updatefish(randomfish, "offlimitfisher")
	currentfishlist = ["RFish", "OFish", "YFish", "GFish", "BFish", "PFish", "WFish", "ZFish"]
	randomfish = currentfishlist.pop_at(randi_range(0, len(currentfishlist) - 1))
	wantedhuntername = randomfish
	updatefish(randomfish, "wantedhunter")
	randomfish = currentfishlist.pop_at(randi_range(0, len(currentfishlist) - 1))
	dudhuntername = randomfish
	updatefish(randomfish, "dudhunter")
	randomfish = currentfishlist.pop_at(randi_range(0, len(currentfishlist) - 1))
	offlimithuntername = randomfish
	updatefish(randomfish, "offlimithunter")
	#Instantiates randomly placed fish on the screen.
	fishcount = randi_range(5, 20)
	for i in fishcount:
		spawnfish = ["RFish", "OFish", "YFish", "GFish", "BFish", "PFish", "WFish", "ZFish"].pick_random()
		instantiate(spawnfish, true)
	#Initial start countdown
	$StartScreen.visible = true
	#tween.tween_property($StartScreen/TransitionColor, "modulate:a", 0, 0.5)
	#await get_tree().create_timer(0.5).timeout
	#$StartScreen/TransitionColor.visible = false
	await get_tree().create_timer(1.0).timeout
	$StartScreen/StartLabel.text = "3..."
	Sfx.play_sound("RoundCountdown")
	await get_tree().create_timer(1.0).timeout
	$StartScreen/StartLabel.text = "2..."
	Sfx.play_sound("RoundCountdown")
	await get_tree().create_timer(1.0).timeout
	$StartScreen/StartLabel.text = "1..."
	Sfx.play_sound("RoundCountdown")
	await get_tree().create_timer(1.0).timeout
	$StartScreen/StartLabel.text = "GO!"
	Sfx.play_sound("RoundStart")
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($StartScreen/StartColor, "modulate:a", 0, 0.5)
	tween.tween_property($StartScreen/StartLabel, "modulate:a", 0, 0.5)
	await get_tree().create_timer(1.0).timeout
	$StartScreen.queue_free()
	paused = false
	start = true
	Cursor.standby = true
	Cursor.timeout = false
	Cursor.shoot = false
	Cursor.reloading = false
	$FisherUI/Timer/Timer.start()
	$Timeout/TimeoutProgress.max_value = timeouttime
	$Timeout/TimeoutProgress.step = timeouttime / 100
	$Reload/ReloadProgress.max_value = reloadtime * bulletmax
	$Reload/ReloadProgress.step = (reloadtime * bulletmax) / 100
	Bgm.get_stream_playback().switch_to_clip_by_name("Game")

#Updates the target fish for the fisher and hunter based on the inputs.
func updatefish(fish : String, box : String):
	var animsprite
	match fish:
		"RFish": animsprite = 0
		"OFish": animsprite = 1
		"YFish": animsprite = 2
		"GFish": animsprite = 3
		"BFish": animsprite = 4
		"PFish": animsprite = 5
		"WFish": animsprite = 6
		"ZFish": animsprite = 7
	match box:
		"wantedfisher": $FisherUI/WantedFish/WantedTexture.frame = animsprite
		"dudfisher": $FisherUI/DudFish/DudTexture.frame = animsprite
		"offlimitfisher": $FisherUI/OffLimitFish/OffLimitTexture.frame = animsprite
		"wantedhunter": $HunterUI/WantedFish/WantedTexture.frame = animsprite
		"dudhunter": $HunterUI/DudFish/DudTexture.frame = animsprite
		"offlimithunter": $HunterUI/OffLimitFish/OffLimitTexture.frame = animsprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$FisherUI/FisherScore/FisherScore.text = str(fisherscore)
	$HunterUI/HunterScore/HunterScore.text = str(hunterscore)
	$Shader.z_index = zindex
	if roundover:
		$EndScreen.visible = true
	if paused:
		Cursor.in_gameplay = false
		$Timeout.visible = false
	elif not paused:
		if spawn and fishcount != fishmax:
			spawn = false
			await get_tree().create_timer(randf_range(0.5, 1.0)).timeout
			spawnfish = ["RFish", "OFish", "YFish", "GFish", "BFish", "PFish", "WFish", "ZFish"].pick_random()
			instantiate(spawnfish, false)
			fishcount += 1
			spawn = true
		if get_global_mouse_position().x >= 420 and get_global_mouse_position().x <= 1500:
			Cursor.in_gameplay = true
		else:
			Cursor.in_gameplay = false
		if Cursor.timeout:
			$Timeout.visible = true
			$Timeout/TimeoutProgress.value = $Timeout/TimeoutTimer.wait_time - $Timeout/TimeoutTimer.time_left
		else:
			$Timeout.visible = false
		if Cursor.reloading:
			$Reload.visible = true
			$Reload/ReloadProgress.value = $Reload/ReloadTimer.wait_time - $Reload/ReloadTimer.time_left
			if $HunterUI/Reloading.visible == false:
				reloading()
		else:
			$Reload.visible = false
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Cursor.in_gameplay and Cursor.standby:
			shooting()

#Shows the end results screen.
func _on_end_screen_visibility_changed() -> void:
	paused = true
	$EndScreen/EndColor.visible = true
	$EndScreen/EndLabel.visible = true
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($EndScreen/EndColor, "modulate:a", 1, 0.5)
	tween.tween_property($EndScreen/EndLabel, "modulate:a", 1, 0.5)
	Bgm.get_stream_playback().switch_to_clip_by_name("Silence")
	Sfx.play_sound("RoundTimeup")
	await get_tree().create_timer(2.5).timeout
	$EndScreen/EndLabel.text = "The result is..."
	Sfx.play_sound("RoundAnticipation")
	if Cursor.compete:
		$EndScreen/EndPopup/Higher.visible = true
		$EndScreen/EndPopup/Lower.visible = true
		if fisherscore > hunterscore:
			$EndScreen/EndPopup/Higher/FisherLogo.visible = true
			$EndScreen/EndPopup/Lower/HunterLogo.visible = true
			$EndScreen/EndPopup/Higher/HigherScore.text = str(fisherscore)
			$EndScreen/EndPopup/Lower/LowerScore.text = str(hunterscore)
			$EndScreen/EndPopup/Winner.text = "FISHER WINS!"
		elif fisherscore < hunterscore:
			$EndScreen/EndPopup/Higher/HunterLogo.visible = true
			$EndScreen/EndPopup/Lower/FisherLogo.visible = true
			$EndScreen/EndPopup/Higher/HigherScore.text = str(hunterscore)
			$EndScreen/EndPopup/Lower/LowerScore.text = str(fisherscore)
			$EndScreen/EndPopup/Winner.text = "HUNTER WINS!"
		elif fisherscore == hunterscore:
			$EndScreen/EndPopup/Lower/LowerBox.visible = false
			$EndScreen/EndPopup/Higher/FisherLogo.visible = true
			$EndScreen/EndPopup/Higher/HigherScore.text = str(fisherscore)
			$EndScreen/EndPopup/Lower/Tie.visible = true
			$EndScreen/EndPopup/Lower/LowerScore.text = str(hunterscore)
			$EndScreen/EndPopup/Winner.text = "IT'S A TIE!"
	else:
		$EndScreen/EndPopup/Collab.visible = true
		$EndScreen/EndPopup/Collab/Score.text = str(fisherscore + hunterscore)
		if fisherscore + hunterscore < 1000:
			$EndScreen/EndPopup/Winner.text = "Congratulations, novice duo!"
			$EndScreen/EndPopup/Collab/Rank1.visible = true
		elif fisherscore + hunterscore < 2000:
			$EndScreen/EndPopup/Winner.text = "Congratulations, impressive duo!"
			$EndScreen/EndPopup/Collab/Rank2.visible = true
		elif fisherscore + hunterscore < 3000:
			$EndScreen/EndPopup/Winner.text = "Congratulations, seasoned duo!"
			$EndScreen/EndPopup/Collab/Rank3.visible = true
		elif fisherscore + hunterscore < 4000:
			$EndScreen/EndPopup/Winner.text = "Congratulations, amazing duo!"
			$EndScreen/EndPopup/Collab/Rank4.visible = true
		elif fisherscore + hunterscore < 5000:
			$EndScreen/EndPopup/Winner.text = "Congratulations, expert duo!"
			$EndScreen/EndPopup/Collab/Rank5.visible = true
		elif fisherscore + hunterscore >= 5000:
			$EndScreen/EndPopup/Winner.text = "Congratulations, legendary duo!"
			$EndScreen/EndPopup/Collab/Rank6.visible = true
	await get_tree().create_timer(2.5).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property($EndScreen/EndLabel, "modulate:a", 0, 0.5)
	tween.tween_property($EndScreen/EndPopup, "modulate:a", 1, 0.5)
	Sfx.play_sound("RoundResults")
	Bgm.get_stream_playback().switch_to_clip_by_name("Main")
	$EndScreen/EndLabel.visible = false
	$EndScreen/EndPopup.visible = true

# Frame rate is synced to the physics. Delta is constant.
func _physics_process(delta: float) -> void:
	if not paused:
		if Input.is_action_pressed("left") and standby: #Control hook going left.
			$Hook.position.x -= hookspeed
			$Hook.position.x = clamp($Hook.position.x, 420, 1425)
			Sfx.play_sound("HookMovehorizontal")
		elif Input.is_action_pressed("right") and standby: #Control hook going right.
			$Hook.position.x += hookspeed
			$Hook.position.x = clamp($Hook.position.x, 420, 1425)
			Sfx.play_sound("HookMovehorizontal")
		elif Input.is_action_pressed("down") and standby: #Control hook going down.
			goingdown = true
			standby = false
		elif Input.is_action_pressed("up") and goingup: #Control hook going up.
			hookspeed = initialspeed * 2 #Speeds up hook.
			Sfx.play_sound("HookMovefast")
		else:
			hookspeed = initialspeed #Set hook speed back to normal.
		if goingdown: #Automates hook going down.
			$Hook.position.y += hookspeed
			$Hook.position.y = clamp($Hook.position.y, -951, -60)
			Sfx.play_sound("HookMovevertical")
		elif goingup: #Automates hook going up. (normal)
			$Hook.position.y -= hookspeed
			$Hook.position.y = clamp($Hook.position.y, -951, -60)
			if shotfish == null:
				if itemhooked == true and itemname != null:
					itemname.position.y -= hookspeed
			else:
				if itemhooked == true and itemname != shotfish:
					itemname.position.y -= hookspeed
			Sfx.play_sound("HookMovevertical")

#Spawns in a new fish.
func instantiate(fishname : String, is_start : bool):
	var instance
	if fishname == "RFish":
		instance = RFish.instantiate()
	elif fishname == "OFish":
		instance = OFish.instantiate()
	elif fishname == "YFish":
		instance = YFish.instantiate()
	elif fishname == "GFish":
		instance = GFish.instantiate()
	elif fishname == "BFish":
		instance = BFish.instantiate()
	elif fishname == "PFish":
		instance = PFish.instantiate()
	elif fishname == "WFish":
		instance = WFish.instantiate()
	elif fishname == "ZFish":
		instance = ZFish.instantiate()
	add_child(instance)
	instance.set_name(fishname)
	instance.position.y = randf_range(400, 900)
	if is_start:
		instance.position.x = randf_range(300, 1500)
		if randi() % 2:
			instance.scale.x = 1
		else:
			instance.scale.x = -1
	else:
		if randi() % 2:
			instance.position.x = 150
			instance.scale.x = 1
		else:
			instance.position.x = 1780
			instance.scale.x = -1
	zindex += 1

#Controls what happens based on what the hook touches.
func _on_hook_area_2d_area_entered(area: Area2D) -> void:
	if area == $BG/Sky and goingup:
		goingup = false
		standby = true
		Sfx.play_sound("HookSplash")
		if shotfish != null:
			if itemhooked == true and itemname != null and itemname != shotfish: #Calculate appropriate results based on the hooked item.
				calculate_fisher()
		else:
			if itemhooked == true and itemname != null: #Calculate appropriate results based on the hooked item.
				calculate_fisher()
	elif area == $BG/Ground:
		goingup = true
	elif area.is_in_group("item") and not goingup:
		goingup = true
		itemname = area
		itemhooked = true
		var tween = create_tween()
		if area.is_in_group("coin"):
			Sfx.play_sound("HookCoin")
			tween.tween_property(itemname, "position", Vector2($Hook.position.x - 65, $Hook.position.y + 980), 0.1)
		else:
			itemname.fishhooked = true
			Sfx.play_sound("HookFish")
			if area.scale.x == 1:
				match itemname.fishname:
					"RFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x - 50, $Hook.position.y + 1020), 0.1)
					"OFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x - 20, $Hook.position.y + 1010), 0.1)
					"YFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x - 20, $Hook.position.y + 1050), 0.1)
					"GFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x - 20, $Hook.position.y + 1000), 0.1)
					"BFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x - 20, $Hook.position.y + 1010), 0.1)
					"PFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x - 50, $Hook.position.y + 1000), 0.1)
					"WFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x - 20, $Hook.position.y + 1000), 0.1)
					"ZFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x - 20, $Hook.position.y + 1020), 0.1)
			else:
				match itemname.fishname:
					"RFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x + 50, $Hook.position.y + 1020), 0.1)
					"OFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x + 50, $Hook.position.y + 1010), 0.1)
					"YFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x + 0, $Hook.position.y + 1050), 0.1)
					"GFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x + 0, $Hook.position.y + 1000), 0.1)
					"BFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x + 0, $Hook.position.y + 1010), 0.1)
					"PFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x + 50, $Hook.position.y + 1000), 0.1)
					"WFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x + 0, $Hook.position.y + 1000), 0.1)
					"ZFish": tween.tween_property(itemname, "position", Vector2($Hook.position.x + 0, $Hook.position.y + 1020), 0.1)
	if goingup: #The hook hits something.
		goingdown = false

func calculate_fisher():
	itemhooked = false
	if itemname.is_in_group("coin"):
		fisherscore += coinpoint
		Sfx.play_sound("RoundCoin")
	else:
		if itemname.get_name().left(5) == wantedfishername:
			fisherscore += wantedfishpoint
			Sfx.play_sound("RoundWanted")
		elif itemname.get_name().left(5) == offlimitfishername:
			fisherscore += offlimitfishpoint
			Sfx.play_sound("RoundOfflimit")
		elif itemname.get_name().left(5) == dudfishername:
			fisherscore += dudfishpoint
			Sfx.play_sound("RoundDud")
		else:
			fisherscore += normalfishpoint
		fishcount -= 1
	itemname.queue_free()

#Detect mouse input if in gameplay center.
func shooting():
	Cursor.standby = false
	$FisherUI/PauseButton.disabled = true
	Cursor.timeout = true
	Cursor.shotposition = get_global_mouse_position()
	$Timeout/Cursor.position = Vector2(Cursor.shotposition.x - 96, Cursor.shotposition.y - 96)
	$Timeout/TimeoutTimer.start(timeouttime)
	$Timeout/TimeoutProgress.position = Vector2(Cursor.shotposition.x - 70, Cursor.shotposition.y + 80)
	Sfx.play_sound("GunTimeout")
	await get_tree().create_timer(timeouttime).timeout
	Cursor.timeout = false
	Cursor.shoot = true
	$Shoot.visible = true
	$Shoot/Cursor.position = Vector2(Cursor.shotposition.x - 96, Cursor.shotposition.y - 96)
	var event_lmb = InputEventMouseButton.new()
	event_lmb.position = Cursor.shotposition
	event_lmb.button_index = 1
	event_lmb.pressed = true
	Input.parse_input_event(event_lmb)
	bulletnum -= 1
	get_node("HunterUI/Bullet" + str(bulletnum)).disabled = true
	await get_tree().create_timer(0.01).timeout
	event_lmb.pressed = false
	Input.parse_input_event(event_lmb)
	if shotgot and shotfish != null:
		shotfish.fishshot = true
		fishcount -= 1
		Sfx.play_sound("GunHit")
		if shotfish.get_name().left(5) == wantedhuntername:
			hunterscore += wantedfishpoint
			Sfx.play_sound("RoundWanted")
		elif shotfish.get_name().left(5) == offlimithuntername:
			hunterscore += offlimitfishpoint
			Sfx.play_sound("RoundOfflimit")
		elif shotfish.get_name().left(5) == dudhuntername:
			hunterscore += dudfishpoint
			Sfx.play_sound("RoundDud")
		else:
			hunterscore += normalfishpoint
	Sfx.play_sound("GunShoot")
	Sfx.play_sound("GunSplash")
	await get_tree().create_timer(shoottime).timeout
	shotgot = false
	Cursor.shoot = false
	$Shoot.visible = false
	if bulletnum == 0:
		Cursor.reloading = true
	else:
		Cursor.standby = true
		$FisherUI/PauseButton.disabled = false
	if shotfish != null:
		shotfish.queue_free()
		shotfish = null

#Reload all bullets.
func reloading():
	$HunterUI/Reloading.visible = true
	$Reload/Cursor.position = Vector2(Cursor.shotposition.x - 96, Cursor.shotposition.y - 96)
	$Reload/ReloadTimer.start(reloadtime * bulletmax)
	$Reload/ReloadProgress.position = Vector2(Cursor.shotposition.x - 70, Cursor.shotposition.y + 80)
	for i in range(bulletmax):
		await get_tree().create_timer(reloadtime).timeout
		get_node("HunterUI/Bullet" + str(bulletnum)).disabled = false
		bulletnum += 1
		Sfx.play_sound("GunReload")
	Cursor.reloading = false
	Cursor.standby = true
	$FisherUI/PauseButton.disabled = false
	$HunterUI/Reloading.visible = false

#Despawns off-screen fish moving left and calculates appropriately.
func _on_fisher_ui_area_entered(area: Area2D) -> void:
	area.queue_free()
	fishcount -= 1

#Despawns off-screen fish moving right and calculates appropriately.
func _on_hunter_ui_area_entered(area: Area2D) -> void:
	area.queue_free()
	fishcount -= 1

#Pause the game.
func _on_pause_button_toggled(toggled_on: bool) -> void:
	if start and not roundover:
		if toggled_on == true:
			paused = true
			$PauseScreen.visible = true
			Bgm.get_stream_playback().switch_to_clip_by_name("Silence")
			Sfx.play_sound("Buttonclick")
		elif toggled_on == false:
			$PauseScreen.visible = false
			await get_tree().create_timer(0.25).timeout
			paused = false
			Bgm.get_stream_playback().switch_to_clip_by_name("Game")

#Resume the round.
func _on_resume_button_button_down() -> void:
	$FisherUI/PauseButton.button_pressed = false
	Sfx.play_sound("Buttonclick")

#Configure settings.
func _on_settings_button_button_down() -> void:
	Sfx.play_sound("Buttonclick")
	$Settings.visible = true
	Cursor.settings = true

#See help screen.
func _on_help_button_button_down() -> void:
	Sfx.play_sound("Buttonclick")
	$Help.visible = true
	Cursor.settings = true

#Go to menu screen.
func _on_menu_button_button_down() -> void:
	Sfx.play_sound("Buttonclick")
	Transition.load_scene("res://MainMenu.tscn")

#Exit the game.
func _on_exit_button_button_down() -> void:
	Sfx.play_sound("Buttonclick")
	get_tree().quit()

#Replay the round.
func _on_replay_button_button_down() -> void:
	Sfx.play_sound("Buttonclick")
	$EndScreen/EndPopup/ReplayButton.disabled = true
	#$EndScreen/TransitionColor.visible = true
	#var tween = create_tween()
	#tween.tween_property($EndScreen/TransitionColor, "modulate:a", 1, 0.5)
	#await get_tree().create_timer(0.5).timeout
	Transition.reload_scene()

#Hover sound effects.
func _on_pause_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_resume_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_settings_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_help_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_menu_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_exit_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

func _on_replay_button_mouse_entered() -> void:
	Sfx.play_sound("Buttonhover")

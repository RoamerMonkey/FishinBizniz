extends Area2D

@onready var childNode = get_node("FishTexture")
#Fish Properties
var fishname #The name of the current fish.
var curfishspeed #How fast the fish is moving
var slowfishspeed = 1
var medifishspeed = 2
var fastfishspeed = 4
var fishhealth #How many hits does it take for the fish to die
var fishhooked = false #Is the fish hooked?
var fishshot = false #Is the fish shot at?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_name($"..".spawnfish)
	fishname = self.get_name().left(5)
	if fishname == "RFish":
		curfishspeed = medifishspeed
		fishhealth = 1
	elif fishname == "OFish":
		curfishspeed = fastfishspeed
		fishhealth = 1
	elif fishname == "YFish":
		curfishspeed = medifishspeed
		fishhealth = 2
	elif fishname == "GFish":
		curfishspeed = slowfishspeed
		fishhealth = 1
	elif fishname == "BFish":
		curfishspeed = slowfishspeed
		fishhealth = 1
	elif fishname == "PFish":
		curfishspeed = fastfishspeed
		fishhealth = 1
	elif fishname == "WFish":
		curfishspeed = slowfishspeed
		fishhealth = 2
	elif fishname == "ZFish":
		curfishspeed = medifishspeed
		fishhealth = 3
	#print("default" + str(fishhealth))
	#childNode.play_anim("default" + str(fishhealth))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fishshot:
		match fishname: #Comment out for only default0 later
			"PFish": pass
			"WFish": pass
			_: childNode.play_anim("default0")

 #Frame rate is synced to the physics. Delta is constant.
func _physics_process(delta: float) -> void:
	if not $"..".paused and not fishhooked and not fishshot:
		if self.scale.x == 1:
			self.position.x += curfishspeed
		elif self.scale.x == -1:
			self.position.x -= curfishspeed

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Cursor.shoot and event.is_action_pressed("click") and not $"..".shotgot:
		$"..".shotfish = self
		$"..".shotgot = true
		

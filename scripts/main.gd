extends Node2D

@export var treeScene: PackedScene
@export var presentScene: PackedScene

var screenSize

func prepareGame():
	## TODO: Want to randomly generate the trees, doesn't work
	#for i in randi_range(1, 5):
		## Make tree
		#var tree = treeScene.instantiate()
		#tree.position = Vector2(randf_range(0.05 * screenSize.x, 0.95 * screenSize.x), randf_range(0.2 * screenSize.y, 0.95 * screenSize.y))
		#add_child(tree)
	pass

func startGame():
	$Player.start($StartPos.position)
	$PresentTimer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called when the player is hit by a present
func gameOver():
	$HUD.gameOver()
	$PresentTimer.stop()

# Make a new present
func _on_present_timer_timeout():
	# Spawn the present
	var present = presentScene.instantiate()
	var spawnLocation = get_node("PresentPath/PresentSpawnLocation")
	spawnLocation.progress_ratio = randf()
	var startPos = spawnLocation.position
	var endPos = $Player.position
	
	# Aim for the player (follow a roughly parabolic path)
	var deltaX = (endPos - startPos).length() * cos((endPos - startPos).angle())
	var deltaY = (endPos - startPos).length() * sin((endPos - startPos).angle())
	
	var t = 2 # Go from current location to player's position in this many seconds
	var g = present.gravity_scale
	var velocity = Vector2(deltaX / t, (deltaY + 0.5  * g * pow(t, 2)) * 1 / t)
	
	present.position = startPos
	present.linear_velocity = velocity
	
	add_child(present)
	
	# Generate a new random wait time
	$PresentTimer.wait_time = randf_range(0.5, 3)
	$PresentTimer.start()

func _on_carrot_holder_shot_present():
	# TODO: Update score
	pass # Replace with function body.

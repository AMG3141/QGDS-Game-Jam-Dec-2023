extends Node

signal shotPresent

@export var carrotScene: PackedScene
var canShoot: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	$CarrotCooldown.start()
	await $CarrotCooldown.timeout
	canShoot = true

func _on_player_shoot(startPos: Vector2, endPos: Vector2):
	if canShoot:
		# Make a new carrot
		var carrot = carrotScene.instantiate()
		
		# Set its rotation to its direction of travel
		carrot.rotation = (endPos - startPos).angle() - PI / 2
		
		add_child(carrot)
		
		carrot.shoot(startPos, endPos, 750)
	
	canShoot = false

func _on_carrot_cooldown_timeout():
	canShoot = true

func _on_carrot_shot_present():
	shotPresent.emit()

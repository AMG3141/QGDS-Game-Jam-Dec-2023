extends RigidBody2D

var explosionType

# Called when the node enters the scene tree for the first time.
func _ready():
	var animations = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var presentTypes = animations.slice(7, 10)
	var explosionTypes = animations.slice(0, 6)
	
	$AnimatedSprite2D.play(presentTypes[randi() % presentTypes.size()])
	explosionType = explosionTypes[randi() % explosionTypes.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func explode():
	linear_velocity = Vector2.ZERO
	gravity_scale = 0
	$AnimatedSprite2D.animation = explosionType
	$CollisionShape2D.set_deferred("disabled", true)
	
	# TODO: probably some other stuff

func remove():
	queue_free()

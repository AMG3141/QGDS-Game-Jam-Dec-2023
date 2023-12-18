extends Area2D

signal shoot
signal hit

@export var maxSpeed = 500
@export var maxAcceleration= 500
@export var keyForce = 100
@export var friction = 15

var velocity: Vector2
var acceleration: Vector2

var screenSize
var shapeSize

func start(pos: Vector2):
	# Initialise vectors
	position = pos
	velocity = Vector2.ZERO
	acceleration = Vector2.ZERO
	$CollisionShape2D.disabled = false
	show()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	# Set up variables
	screenSize = get_viewport_rect().size
	var shape = $CollisionShape2D.shape
	shapeSize = Vector2(shape.radius * 2, shape.height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get user input
	if Input.is_action_pressed("shoot") && visible:
		shoot.emit(Vector2(position.x, position.y - shapeSize.y / 4), get_viewport().get_mouse_position())
	
	var keyPressed = false
	var deltaAcc = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		deltaAcc.x += delta
		keyPressed = true
	if Input.is_action_pressed("move_left"):
		deltaAcc.x -= delta
		keyPressed = true
	if Input.is_action_pressed("move_up"):
		deltaAcc.y -= delta
		keyPressed = true
	if Input.is_action_pressed("move_down"):
		deltaAcc.y += delta
		keyPressed = true
	
	if deltaAcc != Vector2.ZERO:
		deltaAcc = deltaAcc.normalized() * keyForce
	
	# Apply friction
	if !keyPressed:
		deltaAcc = -velocity.normalized() * friction
		
		# Stop shaking
		if abs(velocity.x) < 8 && abs(velocity.y) < 8:
			velocity = Vector2.ZERO
	
	# Update and limit acceleration
	acceleration += deltaAcc
	acceleration = acceleration.normalized() * maxAcceleration if acceleration.length() > maxAcceleration else acceleration
	
	# Update and limit velocity
	velocity += acceleration * delta
	velocity = velocity.normalized() * maxSpeed if velocity.length() > maxSpeed else velocity
	
	# Update and limit position, and do bouncyness
	position += velocity * delta
	
	if position.x < 0 + shapeSize.x * 0.55 || position.x > screenSize.x - shapeSize.y * 0.3:
		velocity.x *= -0.9
	if position.y < 0 + shapeSize.y * 0.85 || position.y > screenSize.y - shapeSize.y * 0.1:
		velocity.y *= -0.9
	
	#position = position.clamp(Vector2.ZERO + shapeSize / 2, screenSize - shapeSize / 2) # For some reason just doesn't work anymore...
	position = position.clamp(Vector2(0 + shapeSize.x * 0.55, 0 + shapeSize.y * 0.85), Vector2(screenSize.x - shapeSize.y * 0.3, screenSize.y - shapeSize.y * 0.1))
	
	# TODO: animation

# When the player hits a tree
func _on_tree_area_entered(area):
	# Bounce player
	velocity *= -0.9

# When a present hits the player
func _on_body_entered(body):
	hit.emit()
	body.explode()
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

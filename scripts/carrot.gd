extends Area2D

signal shotPresent

var velocity: Vector2

var screenSize
var shapeSize

func shoot(startPos: Vector2, endPos: Vector2, speed):
	position = startPos
	velocity = (endPos - startPos).normalized() * speed
	visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up variables
	screenSize = get_viewport_rect().size
	var shape = $CollisionShape2D.shape
	shapeSize = Vector2(shape.radius * 2, shape.height)
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check if the carrot is outside the bounds of the frame
	if position.x < 0 || position.x > screenSize.x || position.y < 0 || position.y > screenSize.y:
		queue_free()
	
	# Move the carrot
	position += velocity * delta

func _on_body_entered(body):
	shotPresent.emit()
	body.explode()
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

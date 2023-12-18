extends CanvasLayer

signal prepareGame
signal startGame

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.disabled = false
	$StartButton.visible = true
	$RestartTimer.stop()

func _on_start_button_pressed():
	$Message.text = "Get Ready"
	$Message.show()
	$Countdown.show()
	$StartButton.visible = false
	$StartButton.disabled = true
	
	prepareGame.emit()
	
	# TODO: How to do this in a loop without it breaking?
	var t = 1.0
	$Countdown.text = "5"
	await get_tree().create_timer(t).timeout
	$Countdown.text = "4"
	await get_tree().create_timer(t).timeout
	$Countdown.text = "3"
	await get_tree().create_timer(t).timeout
	$Countdown.text = "2"
	await get_tree().create_timer(t).timeout
	$Countdown.text = "1"
	await get_tree().create_timer(t).timeout
	
	#for i in range(5, 0):
		#$Countdown.text = i
		#await get_tree().create_timer(1.0).timeout
	
	startGame.emit()
	
	$Message.hide()
	$Countdown.hide()

func gameOver():
	$Message.text = "Game Over"
	$Message.show()
	$RestartTimer.start()

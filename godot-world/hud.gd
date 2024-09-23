extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Kills.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Kills.show()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
	
func update_kills(kills) -> void: 
	$Kills.text = "Kills: %d" % kills
	
func update_total_kills(kills) -> void:
	$TotalKills.text = "TOTAL KILLS: %d" % kills

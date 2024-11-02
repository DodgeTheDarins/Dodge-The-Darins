extends CanvasLayer

signal start_game
signal jeremy

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_message_notimer(text):
	$MessageLabel.text = text
	$MessageLabel.show()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$MessageLabel.text = "Dodge the\nDarrens"
	$MessageLabel.show()
	$StartButton.show()
	$Credits.show()


func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Credits.hide()
	start_game.emit()

func _on_credits_pressed() -> void:
	show_message_notimer("Made by Jeremy and Eric")
	jeremy.emit()

func _on_message_timer_timeout() -> void:
	$MessageLabel.hide()

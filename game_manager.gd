extends Node2D

var score = 0
var total_coins = 5
var score_label: Label
var win_label: Label

func _ready():
	score_label = $UI/ScoreLabel
	win_label = $UI/WinLabel
	update_score()

func collect_coin(coin):
	score += 1
	update_score()
	
	if score >= total_coins:
		win()

func update_score():
	score_label.text = "Score: " + str(score)

func win():
	win_label.visible = true
	
	# Create a celebration effect
	var tween = create_tween()
	tween.tween_property(win_label, "scale", Vector2(1.2, 1.2), 0.3)
	tween.tween_property(win_label, "scale", Vector2(1.0, 1.0), 0.3)
extends Node2D

var player: CharacterBody2D
var coins: Array[Area2D] = []
var score: int = 0
var score_label: Label
var win_label: Label

const TOTAL_COINS = 5

func _ready():
	setup_player()
	setup_coins()
	setup_ui()
	update_score()

func setup_player():
	player = CharacterBody2D.new()
	player.position = Vector2(640, 540)
	add_child(player)
	
	# CollisionShape2D
	var col = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 20
	col.shape = shape
	player.add_child(col)
	
	# Polygon (visual)
	var poly = Polygon2D.new()
	poly.color = Color(0.2, 0.8, 1, 1)
	poly.polygon = PackedVector2Array([
		Vector2(-20, -20), Vector2(20, -20), Vector2(20, 20), Vector2(-20, 20)
	])
	player.add_child(poly)
	
	# Camera
	var cam = Camera2D.new()
	player.add_child(cam)

func setup_coins():
	var positions = [
		Vector2(300, 200), Vector2(600, 150), Vector2(900, 250),
		Vector2(450, 350), Vector2(800, 400)
	]
	
	for pos in positions:
		var coin = Area2D.new()
		coin.position = pos
		coin.body_entered.connect(_on_coin_collected.bind(coin))
		add_child(coin)
		coins.append(coin)
		
		# Collision
		var col = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = 15
		col.shape = shape
		coin.add_child(col)
		
		# Visual (hexagon)
		var poly = Polygon2D.new()
		poly.color = Color(1, 0.84, 0, 1)
		poly.polygon = PackedVector2Array([
			Vector2(-15, 0), Vector2(-7.5, -13), Vector2(7.5, -13),
			Vector2(15, 0), Vector2(7.5, 13), Vector2(-7.5, 13)
		])
		coin.add_child(poly)

func setup_ui():
	var canvas = CanvasLayer.new()
	add_child(canvas)
	
	score_label = Label.new()
	score_label.position = Vector2(20, 20)
	score_label.add_theme_font_size_override("font_size", 32)
	canvas.add_child(score_label)
	
	win_label = Label.new()
	win_label.text = "YOU WIN!"
	win_label.add_theme_font_size_override("font_size", 48)
	win_label.anchors_preset = Control.PRESET_CENTER
	win_label.visible = false
	canvas.add_child(win_label)

func _physics_process(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	var vertical = Input.get_axis("move_up", "move_down")
	var velocity = Vector2(direction, vertical).normalized() * 400
	
	player.velocity = velocity
	player.move_and_slide()
	
	# Screen bounds
	var screen = get_viewport_rect().size
	player.position.x = clamp(player.position.x, 0, screen.x)
	player.position.y = clamp(player.position.y, 0, screen.y)

func _on_coin_collected(body, coin):
	if body == player and is_instance_valid(coin):
		coins.erase(coin)
		coin.queue_free()
		score += 1
		update_score()
		
		if score >= TOTAL_COINS:
			win()

func update_score():
	score_label.text = "Score: " + str(score)

func win():
	win_label.visible = true
	var tween = create_tween()
	tween.tween_property(win_label, "scale", Vector2(1.2, 1.2), 0.3)
	tween.tween_property(win_label, "scale", Vector2(1.0, 1.0), 0.3)
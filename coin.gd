extends Area2D

var collected = false

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and not collected:
		collected = true
		# Notify game manager
		get_parent().collect_coin(self)
		# Animate and hide
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
		tween.tween_callback(queue_free)
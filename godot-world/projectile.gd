extends Area2D

@export var speed: float = 800.0
var velocity = Vector2.ZERO

signal kill

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	position += velocity * delta

	# If the projectile goes off screen
	if not get_viewport_rect().has_point(position):
		queue_free()

func start():
	show()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		kill.emit()
		body.queue_free()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

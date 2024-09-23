extends Area2D
signal hit

@export var speed = 400 # Player base speed
var screen_size # Size of screen

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_click"):
		shoot_projectile()

	var velocity = Vector2.ZERO # Player's movement vector

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	# Check if the Shift key (sprint) is being held down
	var current_speed = speed
	if Input.is_action_pressed("sprint"):  # Shift is held down
		current_speed *= 1.75  # Increase speed by 1.25x

	if velocity.length() > 0:
		velocity = velocity.normalized() * current_speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func shoot_projectile():
	var mouse_position = get_global_mouse_position()
	var projectile = projectile_scene.instantiate()

	# Connect the signal to the main scene
	projectile.connect("kill", Callable(get_parent(), "_on_projectile_kill"))


	projectile.position = global_position
	var direction = (mouse_position - global_position).normalized()
	projectile.velocity = direction * projectile_speed
	get_parent().add_child(projectile)

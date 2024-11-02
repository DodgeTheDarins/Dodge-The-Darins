extends Area2D

signal hit
@export var speed = 600 
var screen_size
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var velocity = Vector2.ZERO # The player's movement vector.
	if dead == false:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("d"):
			velocity.x += 1
		if Input.is_action_pressed("a"):
			velocity.x -= 1
		if Input.is_action_pressed("s"):
			velocity.y += 1
		if Input.is_action_pressed("w"):
			velocity.y -= 1
	
	if dead == true:
		velocity.y = 1



	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		if dead == true:
			$AnimatedSprite2D.play()
			$AnimatedSprite2D.animation = "death"
			$AnimatedSprite2D.flip_v = false
		elif velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			# See the note below about the following boolean assignment.
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite2D.animation = "up"
			$AnimatedSprite2D.flip_v = velocity.y > 0

	else:
		if dead == false:
			$AnimatedSprite2D.play()
			$AnimatedSprite2D.animation = "neutral"
			$AnimatedSprite2D.flip_v = false


	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)



func _on_body_entered(body: Node2D) -> void:
	if $StartTimer.is_stopped() == true:
		hit.emit()
		dead = true
		 #Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	dead = false
	$StartTimer.start()
	await $StartTimer.timeout
	$StartTimer.stop()

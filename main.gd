extends Node

@export var mob_scene: PackedScene
var score

var mobspeedlow = 250
var mobspeedhigh = 350
var mobspeedspecial = 1000.0
var mobspecialchance = 50
var music
var mobspecial

# Called when the node enters the scene tree for the first time.
func _ready(): pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music/Music1.stop()
	$Music/Music2.stop()
	$Music/Music3.stop()
	$Music/Sharks.stop()
	$Music/Shrimp.stop()
	$Music/Jeremy.stop()
	$SFX/DeathSound.play()
	score = 0

func new_game():
	$Music/Jeremy.stop()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	music = randi_range(0,4)
	if music == 0:
		$Music/Music1.play()
	elif music == 1:
		$Music/Music2.play()
	elif music == 2:
		$Music/Music3.play()
	elif music == 3:
		$Music/Sharks.play()
	else:
		$Music/Shrimp.play()
	
func play_jeremy() -> void:
	$Music/Jeremy.play()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	mobspecial = randi_range(0,mobspecialchance)

	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.r
	mob.position = mob_spawn_location.position
	# Add some randomness to the direction.
	if mobspecial != 0:
		direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	var velocity = 0
	# Choose the velocity for the mob.
	if mobspecial == 0:
		velocity = Vector2(mobspeedspecial, 0.0)
	else:
		velocity = Vector2(randf_range(mobspeedlow, mobspeedhigh), 0.0)
	
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

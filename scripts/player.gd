extends CharacterBody2D

const SPEED = 80.0
@onready var sprite: AnimatedSprite2D = $Movement

func _physics_process(_delta):
	#get input direction
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.length():
		velocity = direction * SPEED
		play_animation(direction)
		#look_at(position + direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		sprite.play("Idle")
		
	move_and_slide()

func play_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			sprite.play("Idle")
		else:
			sprite.play("Idle")
	else:
		if dir.y > 0:
			sprite.play("WalkDown")
		else:
			sprite.play("Idle")

extends CharacterBody2D

const SPEED = 70.0
@onready var sprite: AnimatedSprite2D = $Movement

#click to move vars
const clickMoveThreshold = 2
var clickCoord: Vector2 = Vector2.ZERO
var moveToClick: bool = false

#recognizes input as click
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clickCoord = get_global_mouse_position()
		moveToClick = true
	# Cancel click movement if any movement key is pressed
	if event is InputEventKey and event.pressed:
		if Input.is_action_pressed("move_left") \
		or Input.is_action_pressed("move_right") \
		or Input.is_action_pressed("move_up") \
		or Input.is_action_pressed("move_down"):
			moveToClick = false


func _physics_process(_delta):
	#get input direction
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#keyboard movement should have priority over mouse click
	if direction.length():
		velocity = direction * SPEED
		play_animation(direction)
	else:
		if moveToClick:
			var goToTarget = clickCoord - global_position
			if goToTarget.length() < clickMoveThreshold:
				velocity = Vector2.ZERO
				sprite.play("Idle")
				moveToClick = false
			else:
				var moveDirection = goToTarget.normalized()
				velocity = moveDirection * SPEED
				play_animation(moveDirection)
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
			sprite.play("WalkUp")

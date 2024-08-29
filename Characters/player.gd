extends CharacterBody2D


const SPEED = 300.0


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("up"): move(Vector2.UP)
	if Input.is_action_pressed("down"): move(Vector2.DOWN)
	if Input.is_action_pressed("left"): move(Vector2.LEFT)
	if Input.is_action_pressed("right"): move(Vector2.RIGHT)

func move(direction: Vector2):
	# attempt to move in direction
	print(direction)

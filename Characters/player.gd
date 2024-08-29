extends CharacterBody2D


const SPEED = 300.0


func _physics_process(_delta: float) -> void:
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		)
	move(input_direction)

func move(direction: Vector2):
	print(direction)

extends CharacterBody2D


const TILE_SIZE = 16
var is_moving = false


# FIX: refactor to _input() or _unhandled_input() because of diagonal
# movement bug
func _physics_process(_delta: float) -> void:
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		)
	move(input_direction)

func move(direction: Vector2):
	# do not interrupt current movement
	# FIX: probably direction == (0,0) after refactor
	if !is_moving && direction != Vector2(0, 0):
		var new_position = position + direction * TILE_SIZE

		var move_tween = create_tween()
		move_tween.tween_property(self, "position", new_position, 0.2).set_trans(Tween.TRANS_LINEAR)

		is_moving = true

		await move_tween.finished
		is_moving = false

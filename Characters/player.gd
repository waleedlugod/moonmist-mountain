extends CharacterBody2D


const TILE_SIZE = 16
const SPEED = 0.2
var moving_direction = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	move(input_direction)

func move(input_direction: Vector2) -> void:
	# attempt to move if not currently moving and is a valid direction
	if moving_direction == Vector2.ZERO \
	and input_direction != Vector2.ZERO \
	and (input_direction.x == 0 || input_direction.y == 0):
		# determine target position
		moving_direction = input_direction
		var target_position = position + moving_direction * TILE_SIZE

		# tween to new position
		var move_tween = create_tween()
		move_tween.tween_property(
			self,
			"position",
			target_position,
			SPEED
			).set_trans(Tween.TRANS_LINEAR)
		move_tween.tween_callback(func(): moving_direction = Vector2.ZERO)
